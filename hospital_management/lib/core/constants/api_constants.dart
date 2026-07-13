
class AppConstants {
  // base url
  static const String baseUrl = 'http://192.168.0.105';

  // auth end points
  static const String register = '/api/Auth/register';
  static const String login = '/api/Auth/login';

  //  api doctor endpoints
  static const String doctorsEndpoint = '/api/Doctors';

  // patient endpoints
  static const String patientsEndpoint = '/api/Patients';

  // appointment endpoints
  static const String appointmentsEndpoint = '/api/Appointments';

   // medicine endpoints
  static const String medicinesEndpoint = '/api/Medicines';

  // shared preperanfe key
  static const String keyAuthToken = 'auth_token';
  static const String keyAdminName = 'admin_name';
  static const String keyAdminEmail = 'admin_email';
  static const String keyRole = 'user_role';
  static const String keyIsLoggedIn = 'is_logged_in';

  // user role
  static const String roleAdmin = 'admin';
  static const String roleDoctor = 'doctor';
  static const String roleReceptionist = 'receptionist';

  // network
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

}