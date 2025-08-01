import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerCard extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onChooseImage;
  final VoidCallback onRemoveImage;

  const ImagePickerCard({
    super.key,
    required this.selectedImage,
    required this.onChooseImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onChooseImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        child: selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'إضافة صورة للمشكلة',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemoveImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
