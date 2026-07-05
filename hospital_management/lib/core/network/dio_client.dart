import 'package:dio/dio.dart';
import 'package:hospital_management/core/constants/api_constants.dart';
import 'package:hospital_management/core/storage/shared_pref_helper.dart';

class DioClient {
  DioClient._internal();

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio dio = _createDio();

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = PrefHelper.token;

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print(
            'REQUEST[${options.method}] => ${options.baseUrl}${options.path}',
          );
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            'RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
          );
          print(response.data);

          handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            'ERROR[${e.response?.statusCode}] => ${e.requestOptions.path}',
          );
          print(e.message);

          if (e.response?.statusCode == 401) {
            clearAuthToken();
            PrefHelper.clearAuthData();
          }

          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }

  /// Set token after login
  static void setAuthToken(String token) {
    _instance.dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove token after logout
  static void clearAuthToken() {
    _instance.dio.options.headers.remove('Authorization');
  }
}