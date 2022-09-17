class Post {
  final int id;
  final String? title;
  final String? thumbnail;
  final String? agoTime;
  final String? catName;

  const Post({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.agoTime,
    required this.catName,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title']['rendered'],
      thumbnail: json['w2a_by_sourov']['image_thumbnail'],
      agoTime: json['w2a_by_sourov']['ago_time'],
      catName: json['w2a_by_sourov']['catName'],
    );
  }
}
