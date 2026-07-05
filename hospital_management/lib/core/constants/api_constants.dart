
class AppConstants {
  //==================== BASE URL ====================//

  static const String baseUrl = 'http://www.tayab.hospitalms-api.com/';

  //==================== AUTH ENDPOINTS ====================//

  static const String register = '/api/Auth/register';
  static const String login = '/api/Auth/login';

  //==================== API ENDPOINTS ====================//

  static const String doctorsEndpoint = '/api/Doctors';
  static const String patientsEndpoint = '/api/Patients';

  // ভবিষ্যতে আরও যোগ করতে পারো
  // static const String appointmentsEndpoint = '/api/Appointments';
  // static const String medicinesEndpoint = '/api/Medicines';

  //==================== SHARED PREFERENCES KEYS ====================//

  static const String keyAuthToken = 'auth_token';
  static const String keyAdminName = 'admin_name';
  static const String keyAdminEmail = 'admin_email';
  static const String keyRole = 'user_role';
  static const String keyIsLoggedIn = 'is_logged_in';

  //==================== USER ROLES ====================//

  static const String roleAdmin = 'admin';
  static const String roleDoctor = 'doctor';
  static const String roleReceptionist = 'receptionist';

  //==================== NETWORK ====================//

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

}