import 'package:flutter/material.dart';
import 'package:test4/modal/post.dart';

class PostDetails extends StatefulWidget {
  final Post myPostObj;
  const PostDetails({
    Key? key,
    required this.myPostObj,
  }) : super(
          key: key,
        );

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text(widget.myPostObj.title ?? ""),
    );
  }
}
