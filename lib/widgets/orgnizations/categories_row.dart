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
    const categories = ['الكل', 'الاغاثة', 'الصحة', 'التعليم', 'البيئة'];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) =>
            _buildCategoryChip(categories[index], context),
      ),
    );
  }

  Widget _buildCategoryChip(String category, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (selected) => onCategorySelected(category),
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
            color: selectedCategory == category
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
    );
  }
}
