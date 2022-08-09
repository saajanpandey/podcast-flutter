class CategoryPodcastModal {
  int? id;
  String? title;
  int? status;
  List<Category>? category;
  String? artist;
  String? image;
  String? audio;

  CategoryPodcastModal(
      {this.id,
      this.title,
      this.status,
      this.category,
      this.artist,
      this.image,
      this.audio});

  CategoryPodcastModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    artist = json['artist'];
    image = json['image'];
    audio = json['audio'];
  }
}

class Category {
  int? id;
  String? title;
  String? image;

  Category({this.id, this.title, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }
}
