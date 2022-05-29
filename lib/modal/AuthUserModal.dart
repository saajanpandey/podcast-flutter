class AuthUserModal {
  int? id;
  String? name;
  String? email;
  String? dateOfBirth;
  int? gender;
  String? avatar;
  String? message;

  AuthUserModal(
      {this.id,
      this.name,
      this.email,
      this.dateOfBirth,
      this.gender,
      this.avatar,
      this.message});

  AuthUserModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    avatar = json['avatar'];
    message = json['message'] != null ? json['message'] : null;
  }
}
