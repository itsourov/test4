class Post {
  final int id;
  final String? title;
  final String? content;
  final String? date;
  final String? thumbnailSmall;
  final String? thumbnailFull;
  final String? agoTime;
  final String? catName;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.thumbnailSmall,
    required this.thumbnailFull,
    this.agoTime,
    required this.catName,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      date: json['date'],
      thumbnailSmall: json['w2a_by_sourov']['image_thumbnail'],
      thumbnailFull: json['w2a_by_sourov']['image_full'],
      agoTime: json['w2a_by_sourov']['ago_time'],
      catName: json['w2a_by_sourov']['catName'],
    );
  }
}
