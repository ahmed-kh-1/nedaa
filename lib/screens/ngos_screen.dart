import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NGOsScreen extends StatefulWidget {
  const NGOsScreen({super.key});

  @override
  State<NGOsScreen> createState() => _NGOsScreenState();
}

class _NGOsScreenState extends State<NGOsScreen> {
  final List<Map<String, dynamic>> _ngos = List.generate(10, _generateNGO);
  String _searchQuery = '', _selectedCategory = 'الكل';
  bool _showAvailableOnly = false,
      _showHighestRated = false,
      _showNearest = false,
      _isSearching = false;

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
      final matchesSearch = _searchQuery.isEmpty ||
          ngo['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ngo['specialization']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'الكل' ||
          ngo['specialization'] == _selectedCategory;
      final matchesAvailability = !_showAvailableOnly || ngo['isAvailable'];
      return matchesSearch && matchesCategory && matchesAvailability;
    }).toList()
      ..sort((a, b) {
        if (_showHighestRated) return b['rating'].compareTo(a['rating']);
        if (_showNearest) return a['distance'].compareTo(b['distance']);
        return 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching ? _buildSearchField() : const Text('الجمعيات المتاحة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchQuery = '';
            }),
          )
        ],
      ),
      body: Column(children: [
        if (_searchQuery.isNotEmpty) _buildSearchIndicator(),
        _buildCategoriesRow(),
        Expanded(
          child: _filteredNgos.isEmpty && _searchQuery.isNotEmpty
              ? _buildNoResults()
              : _buildNGOsList(),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.filter_alt),
        onPressed: () => _showFilterBottomSheet(context),
      ),
    );
  }

  Widget _buildSearchField() => TextField(
        autofocus: true,
        decoration: const InputDecoration(
            hintText: 'ابحث عن جمعية...', border: InputBorder.none),
        onChanged: (value) => setState(() => _searchQuery = value),
      );

  Widget _buildSearchIndicator() => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.grey[200],
        child: Row(children: [
          Text('نتائج البحث عن: "$_searchQuery"',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => setState(() => _searchQuery = ''))
        ]),
      );

  Widget _buildNoResults() => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text('لا توجد نتائج لـ "$_searchQuery"',
              style: const TextStyle(fontSize: 18, color: Colors.grey)),
          TextButton(
              onPressed: () => setState(() => _searchQuery = ''),
              child: const Text('إعادة تعيين البحث'))
        ],
      ));

  Widget _buildNGOsList() => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredNgos.length,
        itemBuilder: (context, index) => _buildNGOCard(
            context: context, ngo: _filteredNgos[index], index: index),
      );

  Widget _buildNGOCard(
          {required BuildContext context,
          required Map<String, dynamic> ngo,
          required int index}) =>
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
    final categories = const ['الكل', 'الإغاثة', 'الصحة', 'التعليم', 'البيئة'];
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

  void _showFilterBottomSheet(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('تصفية النتائج',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildFilterOption('الجمعيات المتاحة الآن فقط', _showAvailableOnly,
                (v) => setState(() => _showAvailableOnly = v)),
            _buildFilterOption(
                'الأعلى تقييمًا',
                _showHighestRated,
                (v) => setState(() {
                      _showHighestRated = v;
                      if (v) _showNearest = false;
                    })),
            _buildFilterOption(
                'الأقرب إليك',
                _showNearest,
                (v) => setState(() {
                      _showNearest = v;
                      if (v) _showHighestRated = false;
                    })),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('تطبيق التصفية'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ]),
        ),
      );

  Widget _buildFilterOption(
          String title, bool value, Function(bool) onChanged) =>
      ListTile(
        title: Text(title),
        trailing: Switch(value: value, onChanged: onChanged),
      );

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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكن الاتصال بالرقم: $phoneNumber')));
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
}
