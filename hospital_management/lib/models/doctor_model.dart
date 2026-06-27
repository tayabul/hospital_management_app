class DoctorModel {
  final int? doctorID;
  final String? fullName;
  final String? specialty;
  final String? phone;
  final String? email;
  final String? createDate;

  DoctorModel({
    this.doctorID,
    this.fullName,
    this.specialty,
    this.phone,
    this.email,
    this.createDate,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorID: json['doctorID'],
      fullName: json['fullName'],
      specialty: json['specialty'],
      phone: json['phone'],
      email: json['email'],
      createDate: json['createDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorID': doctorID,
      'fullName': fullName,
      'specialty': specialty,
      'phone': phone,
      'email': email,
      'createDate': createDate,
    };
  }
}