import 'package:call/widgets/open%20%20or%20colsed%20card.dart';
import 'package:flutter/material.dart';

class NGOsList extends StatelessWidget {
  final List<Map<String, dynamic>> ngos;
  final Function(Map<String, dynamic>) onNGOTapped;

  const NGOsList({
    super.key,
    required this.ngos,
    required this.onNGOTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: ngos.length,
      itemBuilder: (context, index) => NGOCard(
        ngo: ngos[index],
        index: index,
        onTap: () => onNGOTapped(ngos[index]),
      ),
    );
  }
}
