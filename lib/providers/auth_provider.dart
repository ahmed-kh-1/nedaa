import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String accountType, // 'user' or 'association'
  }) {
    return _authService.signUp(
      email: email,
      password: password,
      name: name,
      accountType: accountType,
    );
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) {
    return _authService.signIn(email: email, password: password);
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
