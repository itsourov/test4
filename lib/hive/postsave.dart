import 'package:hive_flutter/hive_flutter.dart';
part 'postsave.g.dart';

@HiveType(typeId: 0)
class PostSave extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;
  @HiveField(2)
  late String date;
  @HiveField(3)
  late String thumbnailSmall;
  @HiveField(4)
  late String thumbnailFull;

  @HiveField(5)
  late String catName;
}
