class AddFavouriteModal {
  String? message;
  String? status;

  AddFavouriteModal({this.message, this.status});

  AddFavouriteModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
