class AppointmentModel {
  final int? appointmentID;
  final int patientID;
  final int doctorID;
  final DateTime appointmentDate;
  final String status;
  final String? patientName;
  final String? doctorName;

  AppointmentModel({
    this.appointmentID,
    required this.patientID,
    required this.doctorID,
    required this.appointmentDate,
    required this.status,
    this.patientName,
    this.doctorName,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
        appointmentID: json['appointmentID'],
        patientID: json['patientID'],
        doctorID: json['doctorID'],
        appointmentDate: DateTime.parse(json['appointmentDate']),
        status: json['status'] ?? 'Scheduled',
        patientName: json['patientName'],
        doctorName: json['doctorName'],
      );

  Map<String, dynamic> toJson() => {
        if (appointmentID != null) 'appointmentID': appointmentID,
        'patientID': patientID,
        'doctorID': doctorID,
        'appointmentDate': appointmentDate.toIso8601String(),
        'status': status,
      };
}