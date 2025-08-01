// import 'package:call/services/cache_service.dart';
import 'package:call/models/user_model.dart';
import 'package:call/services/auth_service.dart';
import 'package:call/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String accountType, // 'user' or 'association'
  }) async {
    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        accountType: accountType,
      );

      // Save user data after successful signup
      if (result != null) {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;
        if (user != null) {
          final userModel = UserModel(
            id: user.id,
            email: user.email ?? '',
            fullName: name,
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );
          await UserService().saveUser(userModel);
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await _authService.signIn(email: email, password: password);

      // Save user data after successful login
      if (result != null) {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;
        if (user != null) {
          // Try to get existing user data first
          final existingUser = await UserService().getCurrentUser();
          final userModel = existingUser?.copyWith(
                id: user.id,
                email: user.email ?? '',
                lastLoginAt: DateTime.now(),
              ) ??
              UserModel(
                id: user.id,
                email: user.email ?? '',
                fullName: user.userMetadata?['full_name'],
                createdAt: DateTime.now(),
                lastLoginAt: DateTime.now(),
              );
          await UserService().saveUser(userModel);
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword({
    required String newPassword,
  }) {
    return _authService.changePassword(newPassword: newPassword);
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  Session? getSession() {
    return _authService.getSession();
  }
}
