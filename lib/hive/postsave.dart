import 'package:hive_flutter/hive_flutter.dart';
part 'postsave.g.dart';

@HiveType(typeId: 0)
class PostSave extends HiveObject {
  @HiveField(0)
  late String titleSave;

  @HiveField(1)
  late String detailsSave;
}
