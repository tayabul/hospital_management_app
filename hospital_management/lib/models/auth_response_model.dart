class AuthResponseModel {
  final String token;
  final String name;
  final String userName;
  final String role;

  AuthResponseModel({
    required this.token,
    required this.name,
    required this.userName,
    required this.role,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      name: json['name'] ?? '',
      userName: json['userName'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'name': name,
      'userName': userName,
      'role': role,
    };
  }
}
