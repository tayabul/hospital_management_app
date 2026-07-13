import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/api_exception.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final Dio _dio = DioClient().dio;

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _dio.get(AppConstants.appointmentsEndpoint);
      final List data = response.data as List;
      return data.map((json) => AppointmentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AppointmentModel> addAppointment(AppointmentModel appointment) async {
    try {
      final response = await _dio.post(AppConstants.appointmentsEndpoint, data: appointment.toJson());
      return AppointmentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      await _dio.put('${AppConstants.appointmentsEndpoint}/${appointment.appointmentID}', data: appointment.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await _dio.delete('${AppConstants.appointmentsEndpoint}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}