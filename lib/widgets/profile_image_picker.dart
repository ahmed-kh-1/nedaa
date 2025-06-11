import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageChanged;

  const ProfileImagePicker({
    super.key,
    required this.imageUrl,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImageChanged,
      child: CircleAvatar(
        radius: 50,
        backgroundImage:
            NetworkImage(imageUrl ?? 'https://i.pravatar.cc/150?img=8'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.camera_alt, color: Colors.white),
        ),
      ),
    );
  }
}
