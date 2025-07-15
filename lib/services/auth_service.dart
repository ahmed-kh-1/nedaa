import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign up a user.
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String accountType, // 'user' or 'association'
  }) async {
    final response =
        await _supabase.auth.signUp(email: email, password: password, data: {
      "name": name,
      "account_type": accountType,
    });

    final user = response.user;
    if (user == null) {
      throw const AuthException('فشل انشاء الحساب');
    }

    return user.id;
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('فشل تسجيل الدحول');
    }

    return user.id;
  }

  Future<void> changePassword({
    required String newPassword,
  }) async {
    final response = await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (response.user == null) {
      throw const AuthException('فشل تغيير كلمة المرور');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Session? getSession() {
    return _supabase.auth.currentSession;
  }
}
