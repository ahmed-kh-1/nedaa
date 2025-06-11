import 'package:flutter/material.dart';

void showAdoptionConfirmation(BuildContext context, String ngoName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تأكيد التبني'),
      content: Text('هل أنت متأكد من رغبة $ngoName في تبني هذه المشكلة؟'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            _showAdoptionSuccess(context, ngoName);
          },
          child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

void _showAdoptionSuccess(BuildContext context, String ngoName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تم التبني بنجاح'),
      content: Text('تم إرسال طلب التبني إلى $ngoName بنجاح'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('حسناً', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
