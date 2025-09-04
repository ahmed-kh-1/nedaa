import 'package:flutter/material.dart';

class LocationTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onGetLocation;

  const LocationTextField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onGetLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الموقع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'استخدم موقعي الحالي لإنشاء رابط خرائط Google',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: IconButton(
                tooltip: 'استخدم موقعي الآن',
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.my_location,
                        color: theme.colorScheme.primary,
                      ),
                onPressed: isLoading ? null : onGetLocation,
              ),
            ),
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
