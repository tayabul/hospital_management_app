import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // Initialize
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save Auth Data
  static Future<void> saveAuthData({
    required String token,
    required String name,
    required String userName,
    required String role,
  }) async {
    await init();
    await _prefs!.setString(StorageKeys.token, token);
    await _prefs!.setString(StorageKeys.name, name);
    await _prefs!.setString(StorageKeys.userName, userName);
    await _prefs!.setString(StorageKeys.role, role);
    await _prefs!.setBool(StorageKeys.isLoggedIn, true);
  }

  // Get Token
  static Future<String?> getToken() async {
    await init();
    return _prefs!.getString(StorageKeys.token);
  }

   // Get Name
  static Future<String?> getName() async {
    await init();
    return _prefs!.getString(StorageKeys.name);
  }

  // Get UserName
  static Future<String?> getUserName() async {
    await init();
    return _prefs!.getString(StorageKeys.userName);
  }

  // Get Role
  static Future<String?> getRole() async {
    await init();
    return _prefs!.getString(StorageKeys.role);
  }

  // Check Login Status
  static Future<bool> isLoggedIn() async {
    await init();
    return _prefs!.getBool(StorageKeys.isLoggedIn) ?? false;
  }

  // Clear Data (Logout)
  static Future<void> clearAuthData() async {
    await init();
    await _prefs!.remove(StorageKeys.token);
    await _prefs!.remove(StorageKeys.name);
    await _prefs!.remove(StorageKeys.userName);
    await _prefs!.remove(StorageKeys.role);
    await _prefs!.setBool(StorageKeys.isLoggedIn, false);
  }
}
