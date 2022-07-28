class PodcastModal {
  int? id;
  String? title;
  int? status;
  String? category;
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
    category = json['category'];
    artist = json['artist'];
    image = json['image'];
    audio = json['audio'];
    favourite = json['favourite'];
    name = json['name'];
    play = json['play'];
  }
}
