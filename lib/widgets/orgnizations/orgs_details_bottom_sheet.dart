import 'package:call/models/organization_model.dart';
import 'package:call/screens/calls/OrganizationCallsPage.dart';
import 'package:call/widgets/orgnizations/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizationDetailsBottomSheet {
  static void show(BuildContext context, OrganizationModel organization) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _NGOBottomSheetContent(organization: organization),
    );
  }
}

class _NGOBottomSheetContent extends StatelessWidget {
  final OrganizationModel organization;

  const _NGOBottomSheetContent({
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandleIndicator(),
          Text(
            organization.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            organization.shortDescription,
            style: const TextStyle(color: Colors.grey),
          ),
          const Divider(height: 32),
          DetailItem(icon: Icons.phone, text: organization.phone),
          DetailItem(icon: Icons.location_on, text: organization.location),
          DetailItem(icon: Icons.access_time, text: organization.workingHours),
          const SizedBox(height: 24),
          _buildDescription(),
          const Spacer(),
          _buildViewCallsButton(context),
          const SizedBox(height: 8),
          _buildCallButton(context),
        ],
      ),
    );
  }

  Widget _buildHandleIndicator() {
    return Center(
      child: Container(
        width: 60,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نبذة عن الجمعية:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          organization.generalDescription,
        ),
      ],
    );
  }

  Widget _buildCallButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        icon: const Icon(Icons.call),
        label: const Text('الاتصال الآن'),
        onPressed: () => _makePhoneCall(context, organization.phone),
      ),
    );
  }

  Widget _buildViewCallsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.speaker_phone),
        label: const Text('عرض النداءات'),
        onPressed: () => _navigateToCalls(context),
      ),
    );
  }

  void _navigateToCalls(BuildContext context) {
    Navigator.pop(context); // Close the bottom sheet first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganizationCallsPage(organization: organization),
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن الاتصال بالرقم: $phoneNumber')),
      );
    }
  }
}
