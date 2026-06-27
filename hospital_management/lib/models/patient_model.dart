class PatientModel {
  final int? patientID;
  final String? fullName;
  final String? gender;
  final String? dateOfBirth;
  final String? phone;
  final String? email;
  final String? address;
  final String? createDate;

  PatientModel({
    this.patientID,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.email,
    this.address,
    this.createDate,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      patientID: json['patientID'],
      fullName: json['fullName'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      createDate: json['createDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientID': patientID,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
      'email': email,
      'address': address,
      'createDate': createDate,
    };
  }
}