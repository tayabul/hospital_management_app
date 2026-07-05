// lib/core/utils/api_exception.dart

import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(message: 'Connection timed out. Please check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String msg = 'Something went wrong.';
        if (data is Map && data['message'] != null) {
          msg = data['message'];
        } else if (statusCode == 404) {
          msg = 'Resource not found.';
        } else if (statusCode == 401) {
          msg = 'Unauthorized. Please log in again.';
        } else if (statusCode == 500) {
          msg = 'Server error. Please try later.';
        }
        return ApiException(message: msg, statusCode: statusCode);
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection.');
      default:
        return ApiException(message: error.message ?? 'An unexpected error occurred.');
    }
  }

  @override
  String toString() => message;
}