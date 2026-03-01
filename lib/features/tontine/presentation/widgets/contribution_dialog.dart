import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';

class ContributionDialog extends StatefulWidget {
  final Function(File image) onUpload;
  const ContributionDialog({super.key, required this.onUpload});

  @override
  State<ContributionDialog> createState() => _ContributionDialogState();
}

class _ContributionDialogState extends State<ContributionDialog> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.contribute),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Veuillez uploader votre reçu de transfert pour valider votre cotisation.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : const Icon(Icons.add_a_photo_outlined, size: 40),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _selectedImage != null && !_isUploading
              ? () {
                  setState(() => _isUploading = true);
                  widget.onUpload(_selectedImage!);
                  Navigator.pop(context);
                }
              : null,
          child: _isUploading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
