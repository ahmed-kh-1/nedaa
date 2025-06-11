import 'package:call/widgets/categories_row.dart';
import 'package:call/widgets/ngo_details_bottom_sheet.dart';
import 'package:call/widgets/ngos_list.dart';
import 'package:call/widgets/suggest_ngo_bottom_sheet.dart';
import 'package:flutter/material.dart';

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
        CategoriesRow(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) =>
              setState(() => _selectedCategory = category),
        ),
        Expanded(
          child: NGOsList(
            ngos: _filteredNgos,
            onNGOTapped: (ngo) =>
                _showNGODetails(context, ngo['name'], ngo['phone']),
          ),
        ),
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

  void _showNGODetails(BuildContext context, String name, String phone) {
    NGODetailsBottomSheet.show(context, name, phone);
  }

  void _showSuggestNGOBottomSheet(BuildContext context) {
    SuggestNGOBottomSheet.show(context);
  }
}
