class AdminModel {
  final int id;
  final String admin;
  final String password;

  AdminModel({required this.id, required this.admin, required this.password});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      admin: json['admin'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'admin': admin, 'password': password};
  }
}
