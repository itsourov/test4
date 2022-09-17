class Category {
  final int id;
  final int count;
  final String? title;
  final String? thumbnail;

  const Category({
    required this.id,
    required this.count,
    required this.title,
    required this.thumbnail,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      count: json['count'],
      title: json['name'],
      thumbnail: json['featured_image_url'],
    );
  }
}
