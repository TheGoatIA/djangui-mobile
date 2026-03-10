import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/core/widgets/app_button.dart';
import 'package:kauri/core/widgets/app_text_field.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kauri/core/widgets/glass_card.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:kauri/core/mixins/secure_screen_mixin.dart';

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
  String _selectedDocType = 'CNI';
  File? _docImage;
  File? _selfieImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isSelfie) async {
    final XFile? image = await _picker.pickImage(
      source: isSelfie ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        if (isSelfie) {
          _selfieImage = File(image.path);
        } else {
          _docImage = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.kycTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated &&
              Navigator.canPop(context)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.kycStepTitle),
              ),
            );
            Navigator.pop(context);
          }
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.genericError,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.kycStepTitle,
                    style: AppTextStyles.h1.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.kycStepDesc,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AppTextField(
                            controller: _fullNameController,
                            label: AppLocalizations.of(
                              context,
                            )!.kycFullNameLabel,
                            validator: (v) => v?.isEmpty ?? true
                                ? AppLocalizations.of(context)!.required
                                : null,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDocType,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(
                                context,
                              )!.kycDocTypeLabel,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                            items: ['CNI', 'Passport', 'Carte de résident']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedDocType = v!),
                          ),
                          const SizedBox(height: 20),
                          AppTextField(
                            controller: _docNumberController,
                            label: AppLocalizations.of(
                              context,
                            )!.kycDocNumberLabel,
                            validator: (v) => v?.isEmpty ?? true
                                ? AppLocalizations.of(context)!.required
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildImageSelector(
                    AppLocalizations.of(context)!.kycDocPhotoLabel,
                    _docImage,
                    () => _pickImage(false),
                  ),
                  const SizedBox(height: 20),
                  _buildImageSelector(
                    AppLocalizations.of(context)!.kycSelfieLabel,
                    _selfieImage,
                    () => _pickImage(true),
                    isSquare: true,
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    text: AppLocalizations.of(context)!.kycSubmitAction,
                    onPressed: _submitKYC,
                    isLoading: state.status == AuthStatus.loading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSelector(
    String label,
    File? image,
    VoidCallback onTap, {
    bool isSquare = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: isSquare ? 150 : 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.kycUploadClick,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _submitKYC() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_docImage == null || _selfieImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.kycMissingPhotos),
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        AuthSubmitKYCRequested(
          fullName: _fullNameController.text,
          documentType: _selectedDocType,
          documentNumber: _docNumberController.text,
          docFilePath: _docImage!.path,
          selfieFilePath: _selfieImage!.path,
        ),
      );
    }
  }
}
