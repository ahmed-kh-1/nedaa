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
    required String accountType,
  }) async {
    try {
      debugPrint("[AuthProvider] 📩 Signing up user...");
      final result = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        accountType: accountType,
      );

      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user != null) {
        final userModel = UserModel(
          id: user.id,
          email: user.email ?? '',
          fullName: name,
          accountType: accountType,
          createdAt: DateTime.now(),
        );
        await UserService().saveUser(userModel);
        debugPrint("[AuthProvider] ✅ Signup successful and user saved.");
      }

      return result;
    } catch (e) {
      debugPrint("[AuthProvider] ❌ Signup failed: $e");
      rethrow;
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint("[AuthProvider] 📩 Signing in user...");
      final result =
          await _authService.signIn(email: email, password: password);

      if (result != null) {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;

        if (user != null) {
          // 🔹 Fetch name from accounts table
          final accountRes = await supabase
              .from('accounts')
              .select()
              .eq('id', user.id)
              .maybeSingle();

          final accountName = accountRes?['name'] as String?;
          final accountType = accountRes?['account_type'] as String?;

          final existingUser = await UserService().getCurrentUser();
          final userModel = existingUser?.copyWith(
                id: user.id,
                email: user.email ?? '',
                fullName: accountName, // ✅ now we get name from accounts
                lastLoginAt: DateTime.now(),
                accountType: accountType,
              ) ??
              UserModel(
                id: user.id,
                email: user.email ?? '',
                fullName: accountName,
                accountType: accountType,
                createdAt: DateTime.now(),
                lastLoginAt: DateTime.now(),
              );

          debugPrint("$accountName + $accountType + ${user.email}");

          await UserService().saveUser(userModel);
          debugPrint(
              "[AuthProvider] ✅ Signin successful and user saved with name: $accountName");
        }
      }
      return result;
    } catch (e) {
      debugPrint("[AuthProvider] ❌ Signin failed: $e");
      rethrow;
    }
  }

  Future<void> changePassword({
    required String newPassword,
  }) {
    debugPrint("[AuthProvider] 🔑 Changing password...");
    return _authService.changePassword(newPassword: newPassword);
  }

  Future<void> signOut() {
    debugPrint("[AuthProvider] 🚪 Signing out user...");
    return _authService.signOut();
  }

  Session? getSession() {
    return _authService.getSession();
  }
}
