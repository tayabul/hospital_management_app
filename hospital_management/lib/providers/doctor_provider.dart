import 'package:flutter/foundation.dart';
import 'package:hospital_management/models/doctor_model.dart';
import 'package:hospital_management/repositories/doctor_repository.dart';

enum DoctorState { idle, loading, success, error }

class DoctorProvider extends ChangeNotifier {
  final DoctorRepository _repository = DoctorRepository();

  List<DoctorModel> _doctors = [];
  DoctorState _state = DoctorState.idle;
  String? _errorMessage;
  String _searchQuery = '';

// ─── GETTER WITH SEARCH ─────────────────────────────────────────────────
  List<DoctorModel> get doctors {
    if (_searchQuery.isEmpty) return _doctors;
    return _doctors.where((d) =>
      d.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      d.specialty.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      d.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      d.phone.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  DoctorState get state => _state;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isLoading => _state == DoctorState.loading;
  bool get loading => _state == DoctorState.loading;
  String? get error => _errorMessage;


  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ─── FETCH ALL ───────────────────────────────────────────────────────────
  Future<void> fetchDoctors() async {
    _state = DoctorState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _doctors = await _repository.getDoctors();
      _state = DoctorState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = DoctorState.error;
    }
    notifyListeners();
  }

  // ─── ADD ─────────────────────────────────────────────────────────────────
  Future<String?> addDoctor(DoctorModel doctor) async {
    try {
      final created = await _repository.addDoctor(doctor);
      _doctors.add(created);
      notifyListeners();
      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // ─── UPDATE ──────────────────────────────────────────────────────────────
  Future<String?> updateDoctor(DoctorModel doctor) async {
    try {
      await _repository.updateDoctor(doctor);
      final idx = _doctors.indexWhere((d) => d.doctorID == doctor.doctorID);
      if (idx != -1) _doctors[idx] = doctor;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────
  Future<String?> deleteDoctor(int id) async {
    try {
      await _repository.deleteDoctor(id);
      _doctors.removeWhere((d) => d.doctorID == id);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}