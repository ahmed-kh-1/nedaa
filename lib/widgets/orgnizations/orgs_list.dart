import 'package:call/models/organization_model.dart';
import 'package:call/widgets/open%20%20or%20colsed%20card.dart';
import 'package:flutter/material.dart';

class OrganizationsList extends StatelessWidget {
  final List<OrganizationModel> organizations;
  final Function(OrganizationModel) onNGOTapped;

  const OrganizationsList({
    super.key,
    required this.organizations,
    required this.onNGOTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: organizations.length,
      itemBuilder: (context, index) => OrgnizationsCard(
        organization: organizations[index],
        index: index,
        onTap: () => onNGOTapped(organizations[index]),
      ),
    );
  }
}
