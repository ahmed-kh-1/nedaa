import 'package:flutter/material.dart';

class CategoriesRow extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoriesRow({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    const categories = ['الكل', 'الإغاثة', 'الصحة', 'التعليم', 'البيئة'];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) => _buildCategoryChip(categories[index]),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (selected) => onCategorySelected(category),
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(
            color: selectedCategory == category ? Colors.blue : Colors.black),
      ),
    );
  }
}
