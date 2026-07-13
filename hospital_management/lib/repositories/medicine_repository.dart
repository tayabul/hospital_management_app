import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/api_exception.dart';
import '../models/medicine_model.dart';

class MedicineRepository {
  final Dio _dio = DioClient().dio;

  Future<List<MedicineModel>> getMedicines() async {
    try {
      final response = await _dio.get(AppConstants.medicinesEndpoint);
      final List data = response.data as List;
      return data.map((json) => MedicineModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<MedicineModel> addMedicine(MedicineModel medicine) async {
    try {
      final response = await _dio.post(
        AppConstants.medicinesEndpoint, 
        data: medicine.toJson(),
      );
      return MedicineModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      await _dio.put(
        '${AppConstants.medicinesEndpoint}/${medicine.medicineID}', 
        data: medicine.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteMedicine(int id) async {
    try {
      await _dio.delete('${AppConstants.medicinesEndpoint}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}