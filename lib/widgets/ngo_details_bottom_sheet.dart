import 'package:call/widgets/detail_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NGODetailsBottomSheet {
  static void show(BuildContext context, String name, String phone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _NGOBottomSheetContent(name: name, phone: phone),
    );
  }
}

class _NGOBottomSheetContent extends StatelessWidget {
  final String name;
  final String phone;

  const _NGOBottomSheetContent({
    required this.name,
    required this.phone,
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
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'متخصصة في تقديم المساعدات الإنسانية وحالات الطوارئ',
            style: TextStyle(color: Colors.grey),
          ),
          const Divider(height: 32),
          DetailItem(icon: Icons.phone, text: phone),
          const DetailItem(icon: Icons.email, text: 'info@example.com'),
          const DetailItem(icon: Icons.location_on, text: 'دمشق، سوريا'),
          const DetailItem(icon: Icons.access_time, text: 'مفتوح 24/7'),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نبذة عن الجمعية:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'جمعية خيرية مسجلة رسمياً تقدم المساعدات الإنسانية في حالات الكوارث والطوارئ، لديها فرق استجابة سريعة ومراكز إيواء في مختلف المناطق.',
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
        onPressed: () => _makePhoneCall(context, phone),
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
