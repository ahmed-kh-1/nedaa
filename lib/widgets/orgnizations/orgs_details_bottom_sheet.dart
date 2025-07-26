import 'package:call/models/organization_model.dart';
import 'package:call/widgets/detail_item.dart';
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
            style: TextStyle(color: Colors.grey),
          ),
          const Divider(height: 32),
          DetailItem(icon: Icons.phone, text: organization.phone),
          DetailItem(icon: Icons.location_on, text: organization.location),
          DetailItem(icon: Icons.access_time, text: organization.workingHours),
          const SizedBox(height: 24),
          _buildDescription(),
          const Spacer(),
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
        icon: const Icon(Icons.phone),
        label: const Text('الاتصال الآن'),
        onPressed: () => _makePhoneCall(context, organization.phone),
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
