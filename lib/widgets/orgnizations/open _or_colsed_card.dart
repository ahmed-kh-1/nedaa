import 'package:flutter/material.dart';
import 'info_row.dart';
import 'package:call/models/organization_model.dart';

class OrgnizationsCard extends StatelessWidget {
  final OrganizationModel organization;
  final int index;
  final VoidCallback onTap;

  const OrgnizationsCard({
    super.key,
    required this.organization,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
              _buildInfoSection(context),
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
                organization.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                organization.specialization,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoRow(
          icon: Icons.location_on,
          text: organization.location,
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        InfoRow(
          icon: Icons.access_time,
          text: 'مفتوح الآن',
          iconColor: Colors.green,
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
