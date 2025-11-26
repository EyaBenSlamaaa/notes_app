// ============================================
// lib/providers/auth_provider.dart (CORRECTED)
// ============================================
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  dynamic _currentUser; // Use dynamic to match what auth_service returns
  bool _loading = true;

  // Getters
  dynamic get user => _currentUser;
  dynamic get currentUser => _currentUser; // Alias for compatibility
  bool get loading => _loading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    checkAuthStatus();
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    try {
      _loading = true;
      notifyListeners();
      
      _currentUser = await _authService.getCurrentUser();
      
      _loading = false;
      notifyListeners();
    } catch (error) {
      debugPrint('Error checking auth status: $error');
      _currentUser = null;
      _loading = false;
      notifyListeners();
    }
  }

  // Register a new user
  Future<bool> register(String email, String password, String name) async {
    try {
      _loading = true;
      notifyListeners();

      await _authService.createAccount(email, password, name);
      _currentUser = await _authService.getCurrentUser();

      _loading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (error) {
      debugPrint('Registration error: $error');
      _currentUser = null;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // Log in user
  Future<bool> login(String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      await _authService.login(email, password);
      _currentUser = await _authService.getCurrentUser();

      _loading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (error) {
      debugPrint('Login error: $error');
      _currentUser = null;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // Log out user
  Future<void> logout() async {
    try {
      _loading = true;
      notifyListeners();

      await _authService.logout();
      _currentUser = null;

      _loading = false;
      notifyListeners();
    } catch (error) {
      debugPrint('Logout error: $error');
      _currentUser = null;
      _loading = false;
      notifyListeners();
    }
  }
}