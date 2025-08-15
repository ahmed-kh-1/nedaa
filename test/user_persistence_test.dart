import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:call/models/user_model.dart';
import 'package:call/services/user_service.dart';

void main() {
  group('User Persistence Tests', () {
    late UserService userService;

    setUp(() {
      userService = UserService();
    });

    tearDown(() async {
      // Clear shared preferences after each test
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    test('Save and retrieve user data', () async {
      // Create a test user
      final user = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        fullName: 'Test User',
        phone: '123456789',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: DateTime(2023, 1, 1),
        lastLoginAt: DateTime(2023, 1, 2),
      );

      // Save the user
      await userService.saveUser(user);

      // Retrieve the user
      final retrievedUser = await userService.getCurrentUser();

      // Verify the user data
      expect(retrievedUser, isNotNull);
      expect(retrievedUser!.id, equals('test-id'));
      expect(retrievedUser.email, equals('test@example.com'));
      expect(retrievedUser.fullName, equals('Test User'));
      expect(retrievedUser.phone, equals('123456789'));
      expect(retrievedUser.avatarUrl, equals('https://example.com/avatar.jpg'));
      expect(retrievedUser.createdAt, equals(DateTime(2023, 1, 1)));
      expect(retrievedUser.lastLoginAt, equals(DateTime(2023, 1, 2)));
    });

    test('Check if user is logged in', () async {
      // Initially, user should not be logged in
      expect(await userService.isLoggedIn(), isFalse);

      // Create and save a test user
      final user = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        createdAt: DateTime(2023, 1, 1),
      );
      await userService.saveUser(user);

      // Now user should be logged in
      expect(await userService.isLoggedIn(), isTrue);
    });

    test('Clear user data', () async {
      // Create and save a test user
      final user = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        createdAt: DateTime(2023, 1, 1),
      );
      await userService.saveUser(user);

      // Verify user exists
      expect(await userService.getCurrentUser(), isNotNull);
      expect(await userService.isLoggedIn(), isTrue);

      // Clear user data
      await userService.clearUser();

      // Verify user data is cleared
      expect(await userService.getCurrentUser(), isNull);
      expect(await userService.isLoggedIn(), isFalse);
    });

    test('Update user info', () async {
      // Create and save a test user
      final user = UserModel(
        id: 'test-id',
        email: 'test@example.com',
        fullName: 'Test User',
        createdAt: DateTime(2023, 1, 1),
      );
      await userService.saveUser(user);

      // Update user info
      await userService.updateUserInfo(
        fullName: 'Updated User',
        phone: '987654321',
        avatarUrl: 'https://example.com/new-avatar.jpg', 
      );

      // Retrieve updated user
      final updatedUser = await userService.getCurrentUser();

      // Verify updated data
      expect(updatedUser, isNotNull);
      expect(updatedUser!.fullName, equals('Updated User'));
      expect(updatedUser.phone, equals('987654321'));
      expect(updatedUser.avatarUrl, equals('https://example.com/new-avatar.jpg'));
      // Email and id should remain unchanged
      expect(updatedUser.email, equals('test@example.com'));
      expect(updatedUser.id, equals('test-id'));
    });
  });
}
