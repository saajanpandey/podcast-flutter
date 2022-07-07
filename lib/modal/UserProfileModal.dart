class UserProfileModal {
  String? message;
  String? status;

  UserProfileModal({this.message, this.status});

  UserProfileModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
