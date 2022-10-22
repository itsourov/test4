import 'package:flutter/material.dart';
import 'package:test4/views/post_list.dart';

class SearchPost extends StatefulWidget {
  const SearchPost({super.key});

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: TextField(
            onChanged: (text) {
              print('First text field: $text');
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Search Here...',
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: PostListView(null),
        )
      ],
    );
  }
}
