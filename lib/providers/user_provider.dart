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
    if (message != null) {
      debugPrint("[UserProvider] ❌ Error: $message");
    }
    notifyListeners();
  }

  /// Helper for running async methods safely
  Future<void> _runSafe(Future<void> Function() action) async {
    _setLoading(true);
    _setError(null);
    try {
      await action();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUser() async {
    await _runSafe(() async {
      debugPrint("[UserProvider] 📂 Loading user from local storage...");
      _currentUser = await _userService.getCurrentUser();
      if (_currentUser != null) {
        debugPrint("[UserProvider] ✅ User loaded: ${_currentUser!.email}");
      } else {
        debugPrint("[UserProvider] ⚠️ No user found.");
      }
    });
  }

  Future<void> saveUser(UserModel user) async {
    await _runSafe(() async {
      debugPrint("[UserProvider] 💾 Saving user: ${user.email}");
      await _userService.saveUser(user);
      _currentUser = user;
      debugPrint("[UserProvider] ✅ User saved successfully.");
    });
  }

  Future<void> updateUserInfo({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    await _runSafe(() async {
      if (_currentUser != null) {
        debugPrint("[UserProvider] ✏️ Updating user info...");
        await _userService.updateUserInfo(
          fullName: fullName,
          phone: phone,
          avatarUrl: avatarUrl,
        );
        _currentUser = _currentUser!.copyWith(
          fullName: fullName,
          phone: phone,
          avatarUrl: avatarUrl,
        );
        debugPrint("[UserProvider] ✅ User info updated.");
      } else {
        debugPrint("[UserProvider] ⚠️ No user to update.");
      }
    });
  }

  Future<void> updateLastLogin(DateTime lastLogin) async {
    await _runSafe(() async {
      if (_currentUser != null) {
        debugPrint("[UserProvider] ⏳ Updating last login...");
        await _userService.updateLastLogin(lastLogin);
        _currentUser = _currentUser!.copyWith(lastLoginAt: lastLogin);
        debugPrint("[UserProvider] ✅ Last login updated.");
      } else {
        debugPrint("[UserProvider] ⚠️ No user to update last login.");
      }
    });
  }

  Future<void> clearUser() async {
    await _runSafe(() async {
      debugPrint("[UserProvider] 🗑 Clearing user data...");
      await _userService.clearUser();
      _currentUser = null;
      debugPrint("[UserProvider] ✅ User data cleared.");
    });
  }

  bool isLoggedIn() {
    final loggedIn = _currentUser != null;
    debugPrint("[UserProvider] 🔍 isLoggedIn: $loggedIn");
    return loggedIn;
  }
}
