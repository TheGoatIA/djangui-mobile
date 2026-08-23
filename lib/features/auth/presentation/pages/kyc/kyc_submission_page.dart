import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:kauri/core/constants/route_constants.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/core/widgets/app_button.dart';
import 'package:kauri/core/widgets/app_text_field.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kauri/core/widgets/glass_card.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:kauri/core/mixins/secure_screen_mixin.dart';
import 'package:kauri/core/error/error_mapper.dart';

class KYCSubmissionPage extends StatefulWidget {
  const KYCSubmissionPage({super.key});

  @override
  State<KYCSubmissionPage> createState() => _KYCSubmissionPageState();
}

class _KYCSubmissionPageState extends State<KYCSubmissionPage>
    with WidgetsBindingObserver, SecureScreenMixin<KYCSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  String _selectedDocType = 'CNI';
  DateTime? _selectedExpiryDate;

  // Données et URLs existantes préchargées
  String? _existingDocUrl;
  String? _existingDocBackUrl;
  String? _existingSelfieUrl;

  // Fichiers de document locaux
  File? _docFrontFile;
  String? _docFrontName;
  bool _isFrontPdf = false;

  File? _docBackFile;
  String? _docBackName;
  bool _isBackPdf = false;

  // Selfie
  File? _selfieFile;
  bool _isSelfieFlipped = false;

  // Progression de l'upload
  bool _isSubmitting = false;
  double _uploadProgress = 0.0;
  String _uploadStatusText = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initPreloadedData();
  }

  void _initPreloadedData() {
    final user = context.read<AuthBloc>().state.authResponse?.user;
    if (user != null) {
      final kyc = user.kycData;
      if (kyc != null) {
        if (kyc.fullName != null && kyc.fullName!.trim().isNotEmpty) {
          _fullNameController.text = kyc.fullName!;
        } else if (user.fullName.trim().isNotEmpty) {
          _fullNameController.text = user.fullName;
        }

        if (kyc.documentNumber != null && kyc.documentNumber!.trim().isNotEmpty) {
          _docNumberController.text = kyc.documentNumber!;
        }

        if (kyc.documentType != null) {
          final normalized = kyc.documentType!.toLowerCase().replaceAll('_', ' ').trim();
          if (normalized.contains('cni') || normalized.contains('identite')) {
            _selectedDocType = 'CNI';
          } else if (normalized.contains('pass')) {
            _selectedDocType = 'Passport';
          } else if (normalized.contains('permis') || normalized.contains('driver')) {
            _selectedDocType = 'Permis';
          } else if (normalized.contains('resident') || normalized.contains('residence')) {
            _selectedDocType = 'Carte de résident';
          }
        }

        if (kyc.documentExpiryDate != null) {
          _selectedExpiryDate = kyc.documentExpiryDate;
          _expiryDateController.text =
              '${kyc.documentExpiryDate!.day.toString().padLeft(2, '0')}/${kyc.documentExpiryDate!.month.toString().padLeft(2, '0')}/${kyc.documentExpiryDate!.year}';
        }

        _existingDocUrl = kyc.documentImageUrl;
        _existingDocBackUrl = kyc.documentBackImageUrl;
        _existingSelfieUrl = kyc.selfieImageUrl;
      } else {
        if (user.fullName.trim().isNotEmpty) {
          _fullNameController.text = user.fullName;
        }
      }
    }
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();
    final initialDate = _selectedExpiryDate ?? now.add(const Duration(days: 365 * 3));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? initialDate : now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 20)),
      helpText: AppLocalizations.of(context)!.kycDocExpiryLabel,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedExpiryDate = pickedDate;
        _expiryDateController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _docNumberController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  bool get _hasVersoOption =>
      _selectedDocType != 'Passport' && _selectedDocType != 'Passeport';

  /// Sélecteur de document (Photo, Galerie ou Fichier PDF)
  Future<void> _showDocumentPicker(bool isFront) async {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFront
                      ? l10n.kycDocFrontTitle
                      : l10n.kycDocBackTitle,
                  style: AppTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.kycImportMethodTitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_alt, color: AppColors.primary),
                  ),
                  title: Text(l10n.kycImportMethodCamera),
                  subtitle: Text(l10n.kycImportMethodCameraSub),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickDocumentCamera(isFront);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: Text(l10n.kycImportMethodGallery),
                  subtitle: Text(l10n.kycImportMethodGallerySub),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickDocumentGallery(isFront);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  ),
                  title: Text(l10n.kycImportMethodPdf),
                  subtitle: Text(l10n.kycImportMethodPdfSub),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickDocumentPdf(isFront);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDocumentCamera(bool isFront) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    if (image == null || !mounted) return;

    setState(() {
      if (isFront) {
        _docFrontFile = File(image.path);
        _docFrontName = image.name;
        _isFrontPdf = false;
      } else {
        _docBackFile = File(image.path);
        _docBackName = image.name;
        _isBackPdf = false;
      }
    });
  }

  Future<void> _pickDocumentGallery(bool isFront) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    if (image == null || !mounted) return;

    setState(() {
      if (isFront) {
        _docFrontFile = File(image.path);
        _docFrontName = image.name;
        _isFrontPdf = false;
      } else {
        _docBackFile = File(image.path);
        _docBackName = image.name;
        _isBackPdf = false;
      }
    });
  }

  Future<void> _pickDocumentPdf(bool isFront) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty || !mounted) return;
    final file = result.files.first;
    if (file.path == null) return;

    final isPdf = file.extension?.toLowerCase() == 'pdf';

    setState(() {
      if (isFront) {
        _docFrontFile = File(file.path!);
        _docFrontName = file.name;
        _isFrontPdf = isPdf;
      } else {
        _docBackFile = File(file.path!);
        _docBackName = file.name;
        _isBackPdf = isPdf;
      }
    });
  }

  /// Sélecteur de Selfie (Caméra frontale fluide ou Galerie)
  Future<void> _showSelfiePicker() async {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kycSelfieSheetTitle,
                  style: AppTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.kycSelfieSheetSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.face_retouching_natural, color: AppColors.primary),
                  ),
                  title: Text(l10n.kycSelfieCameraTitle),
                  subtitle: Text(l10n.kycSelfieCameraSub),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickSelfieCamera();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: Text(l10n.kycSelfieGalleryTitle),
                  subtitle: Text(l10n.kycSelfieGallerySub),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickSelfieGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickSelfieCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (image == null || !mounted) return;

    setState(() {
      _selfieFile = File(image.path);
      _isSelfieFlipped = false;
    });
  }

  Future<void> _pickSelfieGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (image == null || !mounted) return;

    setState(() {
      _selfieFile = File(image.path);
      _isSelfieFlipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.kycTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated && _isSubmitting) {
            setState(() {
              _isSubmitting = false;
              _uploadProgress = 1.0;
              _uploadStatusText = l10n.kycSuccessTitle;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.kycSuccessSubtitle),
                backgroundColor: AppColors.success,
              ),
            );
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }

          if (state.status == AuthStatus.error) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ErrorMapper.safeMessage(state.errorMessage),
                ),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          final kycLevel = state.authResponse?.user.kycLevel ?? 'none';

          if (!_isSubmitting) {
            if (kycLevel == 'pending') {
              return _buildPendingStateView(context, l10n);
            }
            if (kycLevel == 'verified') {
              return _buildVerifiedStateView(context, l10n);
            }
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (kycLevel == 'rejected' ||
                          kycLevel == 'expired' ||
                          kycLevel == 'update_required') ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: (kycLevel == 'rejected'
                                    ? AppColors.error
                                    : Colors.orange)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (kycLevel == 'rejected'
                                      ? AppColors.error
                                      : Colors.orange)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: kycLevel == 'rejected'
                                    ? AppColors.error
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  kycLevel == 'rejected'
                                      ? l10n.kycRejectedNotice
                                      : l10n.kycUpdateRequiredNotice,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: kycLevel == 'rejected'
                                        ? AppColors.error
                                        : Colors.orange.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Text(
                        l10n.kycStepTitle,
                        style: AppTextStyles.h1.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.kycStepDesc,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Informations Personnelles & Document
                      GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.kycDocInfoTitle,
                                style: AppTextStyles.h3.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _fullNameController,
                                label: l10n.kycFullNameLabel,
                                validator: (v) => v?.trim().isEmpty ?? true
                                    ? l10n.required
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedDocType,
                                decoration: InputDecoration(
                                  labelText: l10n.kycDocTypeLabel,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.surface,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'CNI',
                                    child: Text(l10n.kycDocTypeCni),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Passport',
                                    child: Text(l10n.kycDocTypePassport),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Permis',
                                    child: Text(l10n.kycDocTypeLicense),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Carte de résident',
                                    child: Text(l10n.kycDocTypeResidence),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() {
                                      _selectedDocType = v;
                                      if (!_hasVersoOption) {
                                        _docBackFile = null;
                                        _docBackName = null;
                                        _isBackPdf = false;
                                        _existingDocBackUrl = null;
                                      }
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _docNumberController,
                                label: l10n.kycDocNumberLabel,
                                validator: (v) => v?.trim().isEmpty ?? true
                                    ? l10n.required
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: _selectExpiryDate,
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    controller: _expiryDateController,
                                    label: l10n.kycDocExpiryLabel,
                                    hint: l10n.kycDocExpiryHint,
                                    prefixIcon: Icons.calendar_today_outlined,
                                    validator: (v) {
                                      if (_selectedExpiryDate == null) {
                                        return l10n.kycDocExpiryRequired;
                                      }
                                      if (_selectedExpiryDate!.isBefore(DateTime.now())) {
                                        return l10n.kycDocExpiryInvalid;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Document Recto (Requis)
                      _buildDocumentSlot(
                        title: l10n.kycDocFrontTitle,
                        subtitle: l10n.kycDocFrontSubtitle,
                        file: _docFrontFile,
                        fileName: _docFrontName,
                        existingUrl: _existingDocUrl,
                        isPdf: _isFrontPdf,
                        isRequired: true,
                        onTap: () => _showDocumentPicker(true),
                        onDelete: () => setState(() {
                          _docFrontFile = null;
                          _docFrontName = null;
                          _isFrontPdf = false;
                          _existingDocUrl = null;
                        }),
                      ),
                      const SizedBox(height: 20),

                      // Document Verso (Optionnel / Masqué si passeport)
                      if (_hasVersoOption) ...[
                        _buildDocumentSlot(
                          title: l10n.kycDocBackTitle,
                          subtitle: l10n.kycDocBackSubtitle,
                          file: _docBackFile,
                          fileName: _docBackName,
                          existingUrl: _existingDocBackUrl,
                          isPdf: _isBackPdf,
                          isRequired: false,
                          onTap: () => _showDocumentPicker(false),
                          onDelete: () => setState(() {
                            _docBackFile = null;
                            _docBackName = null;
                            _isBackPdf = false;
                            _existingDocBackUrl = null;
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Selfie
                      _buildSelfieSlot(),
                      const SizedBox(height: 36),

                      // Bouton de soumission
                      AppButton(
                        text: l10n.kycSubmitAction,
                        onPressed: () {
                          if (!_isSubmitting) _submitKYC();
                        },
                        isLoading: _isSubmitting || state.status == AuthStatus.loading,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Modal de progression lors de l'upload
              if (_isSubmitting) _buildUploadProgressOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDocumentSlot({
    required String title,
    required String subtitle,
    required File? file,
    required String? fileName,
    String? existingUrl,
    required bool isPdf,
    required bool isRequired,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final hasExisting = file == null && existingUrl != null && existingUrl.isNotEmpty;
    final isExistingPdf = hasExisting && (existingUrl.toLowerCase().endsWith('.pdf') || existingUrl.toLowerCase().contains('.pdf?'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (isRequired)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.required,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.optional,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (file != null || hasExisting)
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: (file != null || hasExisting) ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: file != null
                ? Stack(
                    children: [
                      if (isPdf)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                size: 50,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  fileName ?? l10n.kycDocPdfLabel,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.kycDocPdfAccepted,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black.withValues(alpha: 0.6),
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 18, color: Colors.white),
                            onPressed: onDelete,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.edit, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                l10n.kycDocChange,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : hasExisting
                    ? Stack(
                        children: [
                          if (isExistingPdf)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf,
                                    size: 50,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.kycExistingDocKept,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.kycDocPdfAccepted,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                existingUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, _, _) => Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.file_present_rounded, size: 40, color: AppColors.primary),
                                      const SizedBox(height: 6),
                                      Text(l10n.kycExistingDocKept),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.edit, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.kycReplaceDoc,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.kycDocPhotoOrPdf,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.kycDocTapToUpload,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelfieSlot() {
    final l10n = AppLocalizations.of(context)!;
    final hasExistingSelfie = _selfieFile == null && _existingSelfieUrl != null && _existingSelfieUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.kycSelfieStepTitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                l10n.required,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.kycSelfieStepSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _showSelfiePicker,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (_selfieFile != null || hasExistingSelfie)
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: (_selfieFile != null || hasExistingSelfie) ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _selfieFile != null
                ? Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              _isSelfieFlipped ? math.pi : 0,
                            ),
                            child: Image.file(
                              _selfieFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black.withValues(alpha: 0.6),
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 18, color: Colors.white),
                            onPressed: () => setState(() {
                              _selfieFile = null;
                              _isSelfieFlipped = false;
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isSelfieFlipped = !_isSelfieFlipped;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.flip, size: 14, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  _isSelfieFlipped ? l10n.kycSelfieMirrorActive : l10n.kycSelfieMirrorToggle,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                l10n.kycSelfieRetake,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : hasExistingSelfie
                    ? Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                _existingSelfieUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, _, _) => const Center(
                                  child: Icon(Icons.face, size: 40),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.kycSelfieRetake,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.face_retouching_natural,
                              size: 36,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.kycSelfieAction,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.kycSelfieActionSub,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  /// Overlay interactif affichant la progression en temps réel
  Widget _buildUploadProgressOverlay() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: Colors.black.withValues(alpha: 0.65),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.kycUploadingTitle,
                style: AppTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _uploadStatusText,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 10,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_uploadProgress * 100).toInt()}%',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitKYC() async {
    final l10n = AppLocalizations.of(context)!;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_docFrontFile == null && _existingDocUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.kycMissingFront),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selfieFile == null && _existingSelfieUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.kycMissingSelfie),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _uploadProgress = 0.15;
      _uploadStatusText = l10n.kycUploadStep1;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() {
      _uploadProgress = 0.45;
      _uploadStatusText = l10n.kycUploadStep2;
    });

    context.read<AuthBloc>().add(
      AuthSubmitKYCRequested(
        fullName: _fullNameController.text.trim(),
        documentType: _selectedDocType,
        documentNumber: _docNumberController.text.trim(),
        expiryDate: _selectedExpiryDate,
        docFilePath: _docFrontFile?.path,
        docBackFilePath: _docBackFile?.path,
        selfieFilePath: _selfieFile?.path,
        existingDocUrl: _existingDocUrl,
        existingDocBackUrl: _existingDocBackUrl,
        existingSelfieUrl: _existingSelfieUrl,
      ),
    );

    // Animation de progression pendant l'attente de la réponse
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _uploadProgress = 0.85;
      _uploadStatusText = l10n.kycUploadStep3;
    });
  }

  Widget _buildPendingStateView(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                size: 72,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(
                    l10n.kycPendingUnderReviewBadge,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.kycPendingPageTitle,
              style: AppTextStyles.h1.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.kycPendingPageSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.kycPendingDocumentsSent,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.kycPendingEstimatedTime,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            AppButton(
              text: l10n.kycBackToProfile,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go(RouteConstants.profile);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedStateView(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 72,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.kycVerifiedDialogTitle,
              style: AppTextStyles.h1.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.kycVerifiedDialogMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            AppButton(
              text: l10n.kycBackToProfile,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go(RouteConstants.profile);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

