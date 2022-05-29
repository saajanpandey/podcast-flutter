class LogoutModal {
  String? message;

  LogoutModal({this.message});

  LogoutModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
