import 'package:flutter/material.dart';
import '../models/call_model.dart';
import '../services/call_service.dart';

class CallProvider with ChangeNotifier {
  final CallService _service = CallService();

  List<CallModel> _calls = [];
  List<CallModel> get calls => _calls;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchCallsByPostId(String postId) async {
    _setLoading(true);
    _setError(null);
    try {
      _calls = await _service.getCallsByPostId(postId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCallsByOrgId(String orgId) async {
    _setLoading(true);
    _setError(null);
    try {
      _calls = await _service.getCallsByOrgId(orgId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addCall(CallModel call) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.addCall(call);
      _calls.insert(0, call); // Add to the beginning of the list
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteCall(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.deleteCall(id);
      _calls.removeWhere((call) => call.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
