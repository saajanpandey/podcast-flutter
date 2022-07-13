class RemoveFavouriteModel {
  String? message;
  String? status;

  RemoveFavouriteModel({this.message, this.status});

  RemoveFavouriteModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
