import 'package:flutter/material.dart';
import 'info_row.dart';

class NGOCard extends StatelessWidget {
  final Map<String, dynamic> ngo;
  final int index;
  final VoidCallback onTap;

  const NGOCard({
    super.key,
    required this.ngo,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildInfoSection(),
              if (ngo['isAvailable']) _buildAvailabilityBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getSpecializationColor().withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getSpecializationIcon(),
            size: 28,
            color: _getSpecializationColor(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ngo['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                ngo['specialization'],
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoRow(
          icon: Icons.star,
          text: ngo['rating'].toStringAsFixed(1),
          iconColor: Colors.amber,
        ),
        InfoRow(
          icon: Icons.location_on,
          text: '${ngo['distance'].toStringAsFixed(1)} كم',
          iconColor: Colors.blue,
        ),
        InfoRow(
          icon: Icons.access_time,
          text: ngo['isAvailable'] ? 'مفتوح الآن' : 'مغلق',
          iconColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildAvailabilityBadge() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'متاحة للاستجابة الفورية',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  IconData _getSpecializationIcon() => const [
        Icons.emergency,
        Icons.medical_services,
        Icons.school,
        Icons.eco,
        Icons.family_restroom
      ][index % 5];

  Color _getSpecializationColor() => const [
        Colors.red,
        Colors.blue,
        Colors.purple,
        Colors.green,
        Colors.orange
      ][index % 5];
}
