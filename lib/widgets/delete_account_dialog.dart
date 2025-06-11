import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback deleteAction;

  const DeleteAccountDialog({super.key, required this.deleteAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('حذف الحساب'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('هل أنت متأكد أنك تريد حذف حسابك؟'),
          SizedBox(height: 8),
          Text(
            'سيتم حذف جميع بياناتك بشكل دائم ولن تتمكن من استرجاعها.',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: deleteAction,
          child: const Text('حذف الحساب'),
        ),
      ],
    );
  }
}
