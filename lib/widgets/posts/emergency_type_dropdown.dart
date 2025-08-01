import 'package:flutter/material.dart';

class EmergencyTypeDropdown extends StatelessWidget {
  final String selectedType;
  final List<String> emergencyTypes;
  final ValueChanged<String?> onChanged;

  const EmergencyTypeDropdown({
    super.key,
    required this.selectedType,
    required this.emergencyTypes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع البلاغ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedType,
            items: emergencyTypes
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        type,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: theme.primaryColor,
            ),
            dropdownColor: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
