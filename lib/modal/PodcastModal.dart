class PodcastModal {
  int? id;
  String? title;
  bool? status;
  String? category;
  String? artist;
  String? image;
  String? audio;

  PodcastModal(
      {this.id,
      this.title,
      this.status,
      this.category,
      this.artist,
      this.image,
      this.audio});

  PodcastModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    category = json['category'];
    artist = json['artist'];
    image = json['image'];
    audio = json['audio'];
  }
}
