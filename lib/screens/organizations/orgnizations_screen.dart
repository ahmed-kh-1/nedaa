import 'package:call/models/organization_model.dart';
import 'package:call/providers/organization_provider.dart';
import 'package:call/widgets/categories_row.dart';
import 'package:call/widgets/orgnizations/orgs_details_bottom_sheet.dart';
import 'package:call/widgets/orgnizations/orgs_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsScreen extends StatefulWidget {
  const OrganizationsScreen({super.key});

  @override
  State<OrganizationsScreen> createState() => _OrganizationsScreenState();
}

class _OrganizationsScreenState extends State<OrganizationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch organizations when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrganizationProvider>().fetchOrganizations();
    });
  }

  String _selectedCategory = 'الكل';

  void _showOrganizationDetails(
      BuildContext context, OrganizationModel organization) {
    OrganizationDetailsBottomSheet.show(context, organization);
  }

  @override
  Widget build(BuildContext context) {
    final organizationProvider = Provider.of<OrganizationProvider>(context);

    return Scaffold(
      body: OrgnizationsBody(
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) =>
            setState(() => _selectedCategory = category),
        organizations: organizationProvider.organizations,
        onNGOTapped: (organization) =>
            _showOrganizationDetails(context, organization),
      ),
    );
  }
}

class OrgnizationsBody extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final List<OrganizationModel> organizations;
  final Function(OrganizationModel) onNGOTapped;
  const OrgnizationsBody({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.organizations,
    required this.onNGOTapped,
  });

  @override
  State<OrgnizationsBody> createState() => _OrgnizationsBodyState();
}

class _OrgnizationsBodyState extends State<OrgnizationsBody> {
  List<OrganizationModel> get filteredOrganizations {
    return widget.organizations.where((organization) {
      final matchesCategory = widget.selectedCategory == 'الكل' ||
          organization.specialization == widget.selectedCategory;
      return matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CategoriesRow(
        selectedCategory: widget.selectedCategory,
        onCategorySelected: widget.onCategorySelected,
      ),
      Expanded(
        child: OrganizationsList(
          organizations: filteredOrganizations,
          onNGOTapped: (organization) => widget.onNGOTapped(organization),
        ),
      ),
    ]);
  }
}
