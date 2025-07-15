import 'package:flutter/material.dart';

enum UserType { user, association }

class UserTypeSelector extends StatelessWidget {
  final UserType selected;
  final ValueChanged<UserType?> onChanged;

  const UserTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<UserType>(
            title: const Text('مستخدم'),
            value: UserType.user,
            groupValue: selected,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: RadioListTile<UserType>(
            title: const Text('جمعية'),
            value: UserType.association,
            groupValue: selected,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
