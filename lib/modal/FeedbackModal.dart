class FeedbackModal {
  String? message;
  String? status;

  FeedbackModal({this.message, this.status});

  FeedbackModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
