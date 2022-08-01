class PodcastModal {
  int? id;
  String? title;
  int? status;
  List<Category>? category;
  String? artist;
  String? image;
  String? audio;
  bool? favourite;
  String? name;
  int? play;

  PodcastModal(
      {this.id,
      this.title,
      this.status,
      this.category,
      this.artist,
      this.image,
      this.audio,
      this.favourite,
      this.name,
      this.play});

  PodcastModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    artist = json['artist'];
    image = json['image'];
    audio = json['audio'];
    favourite = json['favourite'];
    name = json['name'];
    play = json['play'];
  }
}

class Category {
  int? id;
  String? title;

  Category({this.id, this.title});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}
