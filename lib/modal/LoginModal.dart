class LoginModal {
  String? token;
  String? error;

  LoginModal.withError(String errorMessage) {
    error = errorMessage;
  }

  LoginModal({this.token});

  LoginModal.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}
