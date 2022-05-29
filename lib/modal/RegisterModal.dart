class RegisterModal {
  String? token;
  Errors? errors;

  RegisterModal({this.token, this.errors});

  RegisterModal.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
}

class Errors {
  List<String>? email;
  List<String>? password;

  Errors({this.email, this.password});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['email'] != null ? json['email'].cast<String>() : null;
    password =
        json['password'] != null ? json['password'].cast<String>() : null;
  }
}
