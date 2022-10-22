import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test4/hive/postsave.dart';

class BookmarkList extends StatefulWidget {
  const BookmarkList({super.key});

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  var postSaveBox = Hive.box<PostSave>('posts');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: postSaveBox.listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return Text("empty");
        } else {
          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: postSaveBox.keys.length,
              itemBuilder: (context, index) {
                return Text(postSaveBox.getAt(index)?.titleSave ?? "");
              });
        }
      },
    );
  }
}
