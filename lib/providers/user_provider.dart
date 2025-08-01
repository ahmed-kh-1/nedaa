import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final UserService _userService = UserService();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await _userService.getCurrentUser();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveUser(UserModel user) async {
    _setLoading(true);
    _setError(null);
    try {
      await _userService.saveUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserInfo({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_currentUser != null) {
        final updatedUser = _currentUser!.copyWith(
          fullName: fullName,
          phone: phone,
          avatarUrl: avatarUrl,
        );
        await _userService.updateUserInfo(
          fullName: fullName,
          phone: phone,
          avatarUrl: avatarUrl,
        );
        _currentUser = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateLastLogin(DateTime lastLogin) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_currentUser != null) {
        final updatedUser = _currentUser!.copyWith(lastLoginAt: lastLogin);
        await _userService.updateLastLogin(lastLogin);
        _currentUser = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearUser() async {
    _setLoading(true);
    _setError(null);
    try {
      await _userService.clearUser();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  bool isLoggedIn() {
    return _currentUser != null;
  }
}
