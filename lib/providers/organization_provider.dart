import 'package:flutter/material.dart';
import '../models/organization_model.dart';
import '../services/organization_service.dart';

class OrganizationProvider with ChangeNotifier {
  final OrganizationService _service = OrganizationService();

  List<OrganizationModel> _organizations = [];
  List<OrganizationModel> get organizations => _organizations;

  Future<void> fetchOrganizations() async {
    _organizations = await _service.getAllOrganizations();
    notifyListeners();
  }

  Future<void> addOrganization(OrganizationModel org) async {
    await _service.addOrganization(org);
    await fetchOrganizations();
  }

  Future<void> updateOrganization(String id, OrganizationModel org) async {
    await _service.updateOrganization(id, org);
    await fetchOrganizations();
  }

  Future<void> deleteOrganization(String id) async {
    await _service.deleteOrganization(id);
    await fetchOrganizations();
  }

  Future<OrganizationModel?> getOrganizationById(String id) async {
    return await _service.getOrganizationById(id);
  }
}
