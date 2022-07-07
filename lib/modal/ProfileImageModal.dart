class ProfileImageModal {
  String? message;
  String? status;

  ProfileImageModal({this.message, this.status});

  ProfileImageModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
