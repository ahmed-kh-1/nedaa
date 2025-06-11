import 'package:flutter/material.dart';

class AdoptionBottomSheet extends StatelessWidget {
  final String ngoName;

  const AdoptionBottomSheet({super.key, required this.ngoName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandleIndicator(),
          const SizedBox(height: 20),
          _buildVerificationIcon(context),
          _buildSuccessMessage(context),
          _buildNGOInfo(context),
          _buildConfirmationButton(context),
        ],
      ),
    );
  }

  Widget _buildHandleIndicator() {
    return Container(
      width: 60,
      height: 4,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildVerificationIcon(BuildContext context) {
    return Icon(
      Icons.verified,
      color: Theme.of(context).colorScheme.secondary,
      size: 50,
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'تم التبني بنجاح',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'الجمعية المسؤولة:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildNGOInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        ngoName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildConfirmationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'حسناً',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
