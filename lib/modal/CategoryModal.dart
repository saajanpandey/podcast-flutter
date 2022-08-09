class CategoryModal {
  int? id;
  String? title;
  String? image;

  CategoryModal({this.id, this.title, this.image});

  CategoryModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }
}
