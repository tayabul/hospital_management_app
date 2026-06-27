import 'package:flutter/material.dart';
import '../core/storage/shared_pref_helper.dart';
import '../models/auth_response_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  String? _token;
  String? _name;
  String? _userName;
  String? _role;
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;
  String? get token => _token;
  String? get name => _name;
  String? get userName => _userName;
  String? get role => _role;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Check login state on app start
  Future<void> checkLoginStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final loggedIn = await SharedPrefHelper.isLoggedIn();
    if (loggedIn) {
      _token = await SharedPrefHelper.getToken();
      _name = await SharedPrefHelper.getName();
      _userName = await SharedPrefHelper.getUserName();
      _role = await SharedPrefHelper.getRole();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // REGISTER
  Future<bool> register({
    required String name,
    required String userName,
    required String password,
    required String role,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final AuthResponseModel response = await _authService.register(
        name: name,
        userName: userName,
        password: password,
        role: role,
      );

      await SharedPrefHelper.saveAuthData(
        token: response.token,
        name: response.name,
        userName: response.userName,
        role: response.role,
      );

      _token = response.token;
      _name = response.name;
      _userName = response.userName;
      _role = response.role;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // LOGIN
  Future<bool> login({
    required String userName,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final AuthResponseModel response = await _authService.login(
        userName: userName,
        password: password,
      );

      await SharedPrefHelper.saveAuthData(
        token: response.token,
        name: response.name,
        userName: response.userName,
        role: response.role,
      );

      _token = response.token;
      _name = response.name;
      _userName = response.userName;
      _role = response.role;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await SharedPrefHelper.clearAuthData();
    _token = null;
    _name = null;
    _userName = null;
    _role = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
