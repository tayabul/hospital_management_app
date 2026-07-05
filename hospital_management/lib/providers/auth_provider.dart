import 'package:flutter/material.dart';
import 'package:hospital_management/core/storage/shared_pref_helper.dart';
import '../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;

  String? _token;
  String? _name;
  String? _userName;
  String? _role;
  String? _errorMessage;

  //==================== Getters ====================//

  AuthStatus get status => _status;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  bool get isLoading => _status == AuthStatus.loading;

  String? get token => _token;
  String? get name => _name;
  String? get userName => _userName;
  String? get role => _role;

  String get adminName => _name ?? '';

  String get adminEmail => _userName ?? '';

  String? get errorMessage => _errorMessage;

  AuthProvider() {
    //checkLoginStatus();
  }

  //==================== CHECK LOGIN ====================//

Future<bool> checkLoginStatus({bool notify = false}) async {
  _token = PrefHelper.token;
  _name = PrefHelper.adminName;
  _userName = PrefHelper.adminEmail;
  _role = PrefHelper.role;

  if (PrefHelper.isLoggedIn && _token != null && _token!.isNotEmpty) {
    DioClient.setAuthToken(_token!);
    _status = AuthStatus.authenticated;
  } else {
    _status = AuthStatus.unauthenticated;
  }

  if (notify) {
    notifyListeners();
  }

  return isAuthenticated;
}

  //==================== REGISTER ====================//

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
      final response = await _authService.register(
        name: name,
        userName: userName,
        password: password,
        role: role,
      );

      await _saveUser(response);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  //==================== LOGIN ====================//

  Future<bool> login({
    required String userName,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        userName: userName,
        password: password,
      );

      await _saveUser(response);

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  //==================== SAVE USER ====================//

  Future<void> _saveUser(AuthResponseModel response) async {
    _token = response.token;
    _name = response.name;
    _userName = response.userName;
    _role = response.role;

    DioClient.setAuthToken(_token!);

    await PrefHelper.saveLoginState(
      isLoggedIn: true,
      token: _token!,
      email: _userName!,
      name: _name!,
      role: _role!,
    );

    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  //==================== LOGOUT ====================//

  Future<void> logout() async {
    _token = null;
    _name = null;
    _userName = null;
    _role = null;

    DioClient.clearAuthToken();
    await PrefHelper.clearAll();

    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}