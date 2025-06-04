import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NGOsScreen extends StatefulWidget {
  const NGOsScreen({super.key});

  @override
  State<NGOsScreen> createState() => _NGOsScreenState();
}

class _NGOsScreenState extends State<NGOsScreen> {
  final List<Map<String, dynamic>> _ngos = List.generate(10, _generateNGO);
  String _selectedCategory = 'الكل';

  static Map<String, dynamic> _generateNGO(int index) {
    final specializations = [
      'الإغاثة',
      'الصحة',
      'التعليم',
      'البيئة',
      'الإسكان'
    ];
    return {
      'name': 'جمعية الإغاثة الإنسانية ${index + 1}',
      'specialization': specializations[index % specializations.length],
      'rating': 4.5 - (index * 0.2),
      'distance': (index + 1) * 5.0,
      'isAvailable': index % 3 == 0,
      'phone': '+963987654321'
    };
  }

  List<Map<String, dynamic>> get _filteredNgos {
    return _ngos.where((ngo) {
      final matchesCategory = _selectedCategory == 'الكل' ||
          ngo['specialization'] == _selectedCategory;
      return matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _buildCategoriesRow(),
        Expanded(child: _buildNGOsList()),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () => _showSuggestNGOBottomSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('اقتراح جمعية جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildNGOsList() => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredNgos.length,
        itemBuilder: (context, index) => _buildNGOCard(
          context: context,
          ngo: _filteredNgos[index],
          index: index,
        ),
      );

  Widget _buildNGOCard({
    required BuildContext context,
    required Map<String, dynamic> ngo,
    required int index,
  }) =>
      Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _showNGODetails(context, ngo['name'], ngo['phone']),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: _getSpecializationColor(index).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getSpecializationIcon(index),
                      size: 28, color: _getSpecializationColor(index)),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(ngo['name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(ngo['specialization'],
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ])),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildInfoRow(Icons.star, ngo['rating'].toStringAsFixed(1)),
                _buildInfoRow(Icons.location_on,
                    '${ngo['distance'].toStringAsFixed(1)} كم'),
                _buildInfoRow(Icons.access_time,
                    ngo['isAvailable'] ? 'مفتوح الآن' : 'مغلق'),
              ]),
              if (ngo['isAvailable']) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('متاحة للاستجابة الفورية',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ]),
          ),
        ),
      );

  Widget _buildInfoRow(IconData icon, String text) => Row(children: [
        Icon(icon, color: _getIconColor(icon), size: 20),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]);

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.star:
        return Colors.amber;
      case Icons.location_on:
        return Colors.blue;
      case Icons.access_time:
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  Widget _buildCategoriesRow() => SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount:
              const ['الكل', 'الإغاثة', 'الصحة', 'التعليم', 'البيئة'].length,
          itemBuilder: (context, index) => _buildCategoryChip(index),
        ),
      );

  Widget _buildCategoryChip(int index) {
    const categories = ['الكل', 'الإغاثة', 'الصحة', 'التعليم', 'البيئة'];
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ChoiceChip(
        label: Text(categories[index]),
        selected: _selectedCategory == categories[index],
        onSelected: (selected) =>
            setState(() => _selectedCategory = categories[index]),
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(
            color: _selectedCategory == categories[index]
                ? Colors.blue
                : Colors.black),
      ),
    );
  }

  IconData _getSpecializationIcon(int index) => const [
        Icons.emergency,
        Icons.medical_services,
        Icons.school,
        Icons.eco,
        Icons.family_restroom
      ][index % 5];

  Color _getSpecializationColor(int index) => const [
        Colors.red,
        Colors.blue,
        Colors.purple,
        Colors.green,
        Colors.orange
      ][index % 5];

  void _showNGODetails(BuildContext context, String name, String phone) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.7,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
                child: Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            )),
            Text(name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('متخصصة في تقديم المساعدات الإنسانية وحالات الطوارئ',
                style: TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            _buildDetailItem(Icons.phone, phone),
            _buildDetailItem(Icons.email, 'info@example.com'),
            _buildDetailItem(Icons.location_on, 'دمشق، سوريا'),
            _buildDetailItem(Icons.access_time, 'مفتوح 24/7'),
            const SizedBox(height: 24),
            const Text('نبذة عن الجمعية:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'جمعية خيرية مسجلة رسمياً تقدم المساعدات الإنسانية في حالات الكوارث والطوارئ، لديها فرق استجابة سريعة ومراكز إيواء في مختلف المناطق.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('الاتصال الآن'),
                onPressed: () => _makePhoneCall(phone),
              ),
            ),
          ]),
        ),
      );

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن الاتصال بالرقم: $phoneNumber')),
      );
    }
  }

  Widget _buildDetailItem(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 16),
          Text(text),
        ]),
      );

  void _showSuggestNGOBottomSheet(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedSpecialization = 'الإغاثة';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('اقتراح جمعية جديدة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم الجمعية'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            ),
            DropdownButtonFormField<String>(
              value: selectedSpecialization,
              items: ['الإغاثة', 'الصحة', 'التعليم', 'البيئة', 'الإسكان']
                  .map((spec) =>
                      DropdownMenuItem(value: spec, child: Text(spec)))
                  .toList(),
              onChanged: (value) => selectedSpecialization = value ?? 'الإغاثة',
              decoration: const InputDecoration(labelText: 'تخصص الجمعية'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('إرسال الاقتراح'),
                onPressed: () {
                  print('تم اقتراح جمعية:');
                  print('الاسم: ${nameController.text}');
                  print('الهاتف: ${phoneController.text}');
                  print('التخصص: $selectedSpecialization');
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
