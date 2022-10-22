import 'package:flutter/material.dart';
import 'package:test4/modal/category.dart';
import 'package:test4/views/post_list.dart';

class CategoryBasedPostList extends StatelessWidget {
  final Category myCategoryObj;
  const CategoryBasedPostList({
    Key? key,
    required this.myCategoryObj,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(myCategoryObj.title ?? "")),
      body: PostListView(myCategoryObj.id.toString()),
    );
  }
}
