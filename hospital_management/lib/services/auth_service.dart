import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // REGISTER
  Future<AuthResponseModel> register({
    required String name,
    required String userName,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          "name": name,
          "userName": userName,
          "password": password,
          "role": role,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception("Registration failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // LOGIN
  Future<AuthResponseModel> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          "userName": userName,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception("Login failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // Error Handler
  String _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      return "Error: ${e.response?.statusCode} - ${e.response?.statusMessage}";
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please check your internet.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Receive timeout. Server is slow.";
    } else {
      return "Network error: ${e.message}";
    }
  }
}
