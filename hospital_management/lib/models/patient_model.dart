
class PatientModel {
  final int? patientID;
  final String fullName;
  final String gender;
  final String? dateOfBirth;
  final String phone;
  final String email;
  final String address;
  final String? createDate;

  PatientModel({
    this.patientID,
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.address,
    this.createDate,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        patientID: json['patientID'],
        fullName: json['fullName'] ?? '',
        gender: json['gender'] ?? '',
        dateOfBirth: json['dateOfBirth'],
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        address: json['address'] ?? '',
        createDate: json['createDate'],
      );

  Map<String, dynamic> toJson() => {
        if (patientID != null) 'patientID': patientID,
        'fullName': fullName,
        'gender': gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        'phone': phone,
        'email': email,
        'address': address,
      };

  PatientModel copyWith({
    int? patientID,
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? phone,
    String? email,
    String? address,
    String? createDate,
  }) =>
      PatientModel(
        patientID: patientID ?? this.patientID,
        fullName: fullName ?? this.fullName,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        createDate: createDate ?? this.createDate,
      );
}