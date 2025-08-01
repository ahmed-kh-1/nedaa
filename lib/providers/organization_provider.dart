import 'package:call/models/organization_model.dart';
import 'package:call/services/organization_service.dart';
import 'package:flutter/material.dart';

class OrganizationProvider with ChangeNotifier {
  final OrganizationService _service = OrganizationService();

  List<OrganizationModel> _organizations = [];
  List<OrganizationModel> get organizations => _organizations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrganizations() async {
    _setLoading(true);
    try {
      _organizations = await _service.getAllOrganizations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addOrganization(OrganizationModel org) async {
    _setLoading(true);
    try {
      await _service.addOrganization(org);
      await fetchOrganizations();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateOrganization(String id, OrganizationModel org) async {
    _setLoading(true);
    try {
      await _service.updateOrganization(id, org);
      await fetchOrganizations();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteOrganization(String id) async {
    _setLoading(true);
    try {
      await _service.deleteOrganization(id);
      await fetchOrganizations();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<OrganizationModel?> getOrganizationById(String id) async {
    try {
      return await _service.getOrganizationById(id);
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
