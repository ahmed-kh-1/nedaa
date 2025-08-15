import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String _userKey = 'current_user';

  Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toMap());
      await prefs.setString(_userKey, userJson);
      debugPrint("[UserService] ✅ User saved successfully: ${user.email}");
    } catch (e) {
      debugPrint("[UserService] ❌ Failed to save user: $e");
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson);
        final user = UserModel.fromMap(userMap);
        debugPrint("[UserService] ✅ User loaded: ${user.email}");
        return user;
      }
      debugPrint("[UserService] ⚠️ No user found in storage.");
    } catch (e) {
      debugPrint("[UserService] ❌ Failed to load user: $e");
    }
    return null;
  }

  Future<void> updateLastLogin(DateTime lastLogin) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(lastLoginAt: lastLogin);
      await saveUser(updatedUser);
      debugPrint("[UserService] ✅ Last login updated.");
    } else {
      debugPrint("[UserService] ⚠️ No user to update last login.");
    }
  }

  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      debugPrint("[UserService] ✅ User data cleared.");
    } catch (e) {
      debugPrint("[UserService] ❌ Failed to clear user data: $e");
    }
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
      debugPrint("[UserService] ✅ User info updated.");
    } else {
      debugPrint("[UserService] ⚠️ No user to update info.");
    }
  }
}
