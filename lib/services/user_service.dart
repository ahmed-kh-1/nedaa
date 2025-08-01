import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> saveUser(UserModel user) async {
    debugPrint("saving user: $user");
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toMap());
    await prefs.setString(_userKey, userJson);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> updateLastLogin(DateTime lastLogin) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(lastLoginAt: lastLogin);
      await saveUser(updatedUser);
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<void> updateUserInfo({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      await saveUser(updatedUser);
    }
  }
}
