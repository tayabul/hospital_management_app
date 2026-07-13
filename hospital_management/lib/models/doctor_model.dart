
class DoctorModel {
  final int? doctorID;
  final String fullName;
  final String specialty;
  final String phone;
  final String email;
  final String? createDate;

  DoctorModel({
    this.doctorID,
    required this.fullName,
    required this.specialty,
    required this.phone,
    required this.email,
    this.createDate,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        doctorID: json['doctorID'],
        fullName: json['fullName'] ?? '',
        specialty: json['specialty'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        createDate: json['createDate'],
      );

  Map<String, dynamic> toJson() => {
        if (doctorID != null) 'doctorID': doctorID,
        'fullName': fullName,
        'specialty': specialty,
        'phone': phone,
        'email': email,
      };

  DoctorModel copyWith({
    int? doctorID,
    String? fullName,
    String? specialty,
    String? phone,
    String? email,
    String? createDate,
  }) =>
      DoctorModel(
        doctorID: doctorID ?? this.doctorID,
        fullName: fullName ?? this.fullName,
        specialty: specialty ?? this.specialty,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        createDate: createDate ?? this.createDate,
      );
}