import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';

  /// Save user data (name & email)
  Future<void> saveUserData({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
  }

  /// Get user data (returns null if not found)
  Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    if (name != null && email != null) {
      return {'name': name, 'email': email};
    }
    return null; // No user data stored
  }

  /// Clear user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
  }
}
