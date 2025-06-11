import 'package:flutter/material.dart';

class SuggestNGOBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _SuggestNGOForm(),
    );
  }
}

class _SuggestNGOForm extends StatefulWidget {
  const _SuggestNGOForm();

  @override
  State<_SuggestNGOForm> createState() => __SuggestNGOFormState();
}

class __SuggestNGOFormState extends State<_SuggestNGOForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedSpecialization = 'الإغاثة';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اقتراح جمعية جديدة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFormFields(),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'اسم الجمعية'),
        ),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'رقم الهاتف'),
        ),
        DropdownButtonFormField<String>(
          value: _selectedSpecialization,
          items: ['الإغاثة', 'الصحة', 'التعليم', 'البيئة', 'الإسكان']
              .map((spec) => DropdownMenuItem(
                    value: spec,
                    child: Text(spec),
                  ))
              .toList(),
          onChanged: (value) =>
              setState(() => _selectedSpecialization = value ?? 'الإغاثة'),
          decoration: const InputDecoration(labelText: 'تخصص الجمعية'),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Text('إرسال الاقتراح'),
        onPressed: _submitSuggestion,
      ),
    );
  }

  void _submitSuggestion() {
    print('تم اقتراح جمعية:');
    print('الاسم: ${_nameController.text}');
    print('الهاتف: ${_phoneController.text}');
    print('التخصص: $_selectedSpecialization');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
