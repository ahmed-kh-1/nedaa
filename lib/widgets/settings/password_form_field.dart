import 'package:flutter/material.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final VoidCallback onToggleVisibility;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.prefixIcon,
    required this.validator,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
