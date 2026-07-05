import 'package:dio/dio.dart';
import 'package:hospital_management/core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/api_exception.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  final Dio _dio = DioClient().dio;

  // ─── GET ALL ─────────────────────────────────────────────────────────────
  Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await _dio.get(AppConstants.doctorsEndpoint);

      final List data = response.data as List;
      return data.map((json) => DoctorModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── GET BY ID ───────────────────────────────────────────────────────────
  Future<DoctorModel> getDoctorById(int id) async {
    try {
      final response = await _dio.get(
        '${AppConstants.doctorsEndpoint}/$id',
      );

      return DoctorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── CREATE ──────────────────────────────────────────────────────────────
  Future<DoctorModel> addDoctor(DoctorModel doctor) async {
    try {
      final response = await _dio.post(
        AppConstants.doctorsEndpoint,
        data: doctor.toJson(),
      );

      return DoctorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── UPDATE ──────────────────────────────────────────────────────────────
  Future<void> updateDoctor(DoctorModel doctor) async {
    try {
      await _dio.put(
        '${AppConstants.doctorsEndpoint}/${doctor.doctorID}',
        data: doctor.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────
  Future<void> deleteDoctor(int id) async {
    try {
      await _dio.delete(
        '${AppConstants.doctorsEndpoint}/$id',
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}