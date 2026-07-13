import 'package:flutter/foundation.dart';
import 'package:hospital_management/models/medicine_model.dart';
import 'package:hospital_management/repositories/medicine_repository.dart';

enum MedicineState { idle, loading, success, error }

class MedicineProvider extends ChangeNotifier {
  final MedicineRepository _repository = MedicineRepository();

  List<MedicineModel> _medicines = [];
  MedicineState _state = MedicineState.idle;
  String? _errorMessage;
  String _searchQuery = '';

  List<MedicineModel> get medicines {
    if (_searchQuery.isEmpty) return _medicines;
    final q = _searchQuery.toLowerCase();
    return _medicines.where((m) =>
      (m.name.toLowerCase().contains(q)) ||
      (m.description?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchMedicines() async {
    _state = MedicineState.loading;
    notifyListeners();
    try {
      _medicines = await _repository.getMedicines();
      _state = MedicineState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = MedicineState.error;
    }
    notifyListeners();
  }

  // ==================== ADD, UPDATE, DELETE ====================

  Future<void> addMedicine(MedicineModel medicine) async {
    try {
      final newMedicine = await _repository.addMedicine(medicine);
      _medicines.add(newMedicine);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      await _repository.updateMedicine(medicine);
      final index = _medicines.indexWhere((m) => m.medicineID == medicine.medicineID);
      if (index != -1) {
        _medicines[index] = medicine;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> deleteMedicine(int id) async {
    try {
      await _repository.deleteMedicine(id);
      _medicines.removeWhere((m) => m.medicineID == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  // Getter
  MedicineState get state => _state;
  String? get errorMessage => _errorMessage;
}