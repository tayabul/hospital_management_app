// lib/data/repositories/patient_repository.dart

import 'package:dio/dio.dart';
import 'package:hospital_management/core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/api_exception.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final Dio _dio = DioClient().dio;

  // ─── GET ALL ─────────────────────────────────────────────────────────────
  Future<List<PatientModel>> getPatients() async {
    try {
      final response = await _dio.get(AppConstants.patientsEndpoint);
      final List data = response.data as List;
      return data.map((json) => PatientModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── GET BY ID ───────────────────────────────────────────────────────────
  Future<PatientModel> getPatientById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.patientsEndpoint}/$id');
      return PatientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── CREATE ──────────────────────────────────────────────────────────────
  Future<PatientModel> addPatient(PatientModel patient) async {
    try {
      final response = await _dio.post(
        AppConstants.patientsEndpoint,
        data: patient.toJson(),
      );
      return PatientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── UPDATE ──────────────────────────────────────────────────────────────
  Future<void> updatePatient(PatientModel patient) async {
    try {
      await _dio.put(
        '${AppConstants.patientsEndpoint}/${patient.patientID}',
        data: patient.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────
  Future<void> deletePatient(int id) async {
    try {
      await _dio.delete('${AppConstants.patientsEndpoint}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}