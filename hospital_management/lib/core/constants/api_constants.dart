class ApiConstants {
  static const String baseUrl = "http://www.tayab.hospitalms-api.com/";

  // Auth Endpoints
  static const String register = "/api/Auth/register";
  static const String login = "/api/Auth/login";

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}

class StorageKeys {
  static const String token = "auth_token";
  static const String name = "name";
  static const String userName = "user_name";
  static const String role = "user_role";
  static const String isLoggedIn = "is_logged_in";
}

class UserRoles {
  static const String admin = "admin";
  static const String doctor = "doctor";
  static const String receptionist = "receptionist";
}
