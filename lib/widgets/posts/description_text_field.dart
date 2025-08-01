import 'package:flutter/material.dart';

class DescriptionTextField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'وصف المشكلة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'أدخل وصفًا تفصيليًا للمشكلة...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
            validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال وصف المشكلة' : null,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
