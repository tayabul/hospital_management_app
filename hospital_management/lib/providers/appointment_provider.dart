import 'package:flutter/foundation.dart';
import 'package:hospital_management/models/appointment_model.dart';
import 'package:hospital_management/repositories/appointment_repository.dart';

enum AppointmentState { idle, loading, success, error }

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();

  List<AppointmentModel> _appointments = [];
  AppointmentState _state = AppointmentState.idle;
  String? _errorMessage;
  String _searchQuery = '';

  List<AppointmentModel> get appointments {
    if (_searchQuery.isEmpty) return _appointments;
    final q = _searchQuery.toLowerCase();
    return _appointments.where((a) =>
      (a.patientName?.toLowerCase().contains(q) ?? false) ||
      (a.doctorName?.toLowerCase().contains(q) ?? false) ||
      a.status.toLowerCase().contains(q)
    ).toList();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchAppointments() async {
    _state = AppointmentState.loading;
    notifyListeners();
    try {
      _appointments = await _repository.getAppointments();
      _state = AppointmentState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AppointmentState.error;
    }
    notifyListeners();
  }

  // ==================== CRUD Operations ====================

  Future<void> addAppointment(AppointmentModel appointment) async {
    try {
      final newAppointment = await _repository.addAppointment(appointment);
      _appointments.add(newAppointment);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      await _repository.updateAppointment(appointment);
      final index = _appointments.indexWhere((a) => a.appointmentID == appointment.appointmentID);
      if (index != -1) {
        _appointments[index] = appointment;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await _repository.deleteAppointment(id);
      _appointments.removeWhere((a) => a.appointmentID == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  // Getters
  AppointmentState get state => _state;
  String? get errorMessage => _errorMessage;
}