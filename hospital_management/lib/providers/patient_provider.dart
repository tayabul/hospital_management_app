
import 'package:flutter/foundation.dart';
import 'package:hospital_management/models/patient_model.dart';
import 'package:hospital_management/repositories/patient_repository.dart';

enum PatientState { idle, loading, success, error }

class PatientProvider extends ChangeNotifier {
  final PatientRepository _repository = PatientRepository();

  List<PatientModel> _patients = [];
  PatientState _state = PatientState.idle;
  String? _errorMessage;
  String _searchQuery = '';

  List<PatientModel> get patients {
    if (_searchQuery.isEmpty) return _patients;
    return _patients.where((p) =>
      p.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.phone.contains(_searchQuery)
    ).toList();
  }

  PatientState get state => _state;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isLoading => _state == PatientState.loading;



  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ─── FETCH ALL ───────────────────────────────────────────────────────────
  Future<void> fetchPatients() async {
    _state = PatientState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _patients = await _repository.getPatients();
      _state = PatientState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = PatientState.error;
    }
    notifyListeners();
  }

  // ─── ADD ─────────────────────────────────────────────────────────────────
  Future<String?> addPatient(PatientModel patient) async {
    try {
      final created = await _repository.addPatient(patient);
      _patients.add(created);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // ─── UPDATE ──────────────────────────────────────────────────────────────
  Future<String?> updatePatient(PatientModel patient) async {
    try {
      await _repository.updatePatient(patient);
      final idx = _patients.indexWhere((p) => p.patientID == patient.patientID);
      if (idx != -1) _patients[idx] = patient;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // ─── DELETE ──────────────────────────────────────────────────────────────
  Future<String?> deletePatient(int id) async {
    try {
      await _repository.deletePatient(id);
      _patients.removeWhere((p) => p.patientID == id);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}