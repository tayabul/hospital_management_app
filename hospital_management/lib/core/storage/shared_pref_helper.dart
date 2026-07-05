
import 'package:hospital_management/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static SharedPreferences? _prefs;

  // Initialize
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
        'PrefHelper not initialized. Call PrefHelper.init() first.',
      );
    }
    return _prefs!;
  }

  //==================== SAVE LOGIN DATA ====================//

  static Future<void> saveLoginState({
    required bool isLoggedIn,
    required String email,
    required String name,
    required String token,
    String role = '',
  }) async {
    await _instance.setBool(AppConstants.keyIsLoggedIn, isLoggedIn);
    await _instance.setString(AppConstants.keyAdminEmail, email);
    await _instance.setString(AppConstants.keyAdminName, name);
    await _instance.setString(AppConstants.keyAuthToken, token);
    await _instance.setString(AppConstants.keyRole, role);
  }

  //==================== GETTERS ====================//

  static bool get isLoggedIn =>
      _instance.getBool(AppConstants.keyIsLoggedIn) ?? false;

  static String get adminEmail =>
      _instance.getString(AppConstants.keyAdminEmail) ?? '';

  static String get adminName =>
      _instance.getString(AppConstants.keyAdminName) ?? '';

  static String get token =>
      _instance.getString(AppConstants.keyAuthToken) ?? '';

  static String get role =>
      _instance.getString(AppConstants.keyRole) ?? '';

  // Optional aliases (আগের কোডের compatibility-এর জন্য)

  static String get authToken => token;

  static String get userName => adminEmail;

  static String get name => adminName;

  //==================== CLEAR ====================//

  static Future<void> clearAuthData() async {
    await _instance.remove(AppConstants.keyIsLoggedIn);
    await _instance.remove(AppConstants.keyAdminEmail);
    await _instance.remove(AppConstants.keyAdminName);
    await _instance.remove(AppConstants.keyAuthToken);
    await _instance.remove(AppConstants.keyRole);
  }

  static Future<void> clearAll() async {
    //await _instance.clear();
    await clearAuthData();
  }

  
}