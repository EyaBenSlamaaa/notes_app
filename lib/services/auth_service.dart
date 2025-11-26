// lib/services/auth_service.dart
import 'dart:developer' as developer;
import 'package:appwrite/appwrite.dart' as aw;
import '../services/appwrite_config.dart';

class AuthService {
  late final aw.Account account;

  AuthService() {
    account = aw.Account(AppwriteConfig.client);
  }

  // Register a new user
  Future<dynamic> createAccount(String email, String password, String name) async {
    try {
      final user = await account.create(
        userId: aw.ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // Auto-login after creating account
      if (user.$id.isNotEmpty) {
        return await login(email, password);
      } else {
        throw Exception('Failed to create account');
      }
    } catch (error) {
      developer.log('Error creating account: $error');
      rethrow;
    }
  }

  // Login existing user
Future<dynamic> login(String email, String password) async {
  try {
    final session = await account.createEmailPasswordSession(
      email: email,
      password: password,
    );

    developer.log('Login success: $session');
    return session;
  } catch (error) {
    developer.log('Error logging in: $error');
    rethrow;
  }
}



  // Get the current user
  Future<dynamic> getCurrentUser() async {
    try {
      final user = await account.get();
      return user;
    } catch (error) {
      developer.log('Error getting current user: $error');
      return null;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (error) {
      developer.log('Error logging out: $error');
      rethrow;
    }
  }
}
