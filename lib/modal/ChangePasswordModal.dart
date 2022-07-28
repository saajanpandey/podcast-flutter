class ChangePasswordModal {
  String? message;
  String? status;

  ChangePasswordModal({this.message, this.status});

  ChangePasswordModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}