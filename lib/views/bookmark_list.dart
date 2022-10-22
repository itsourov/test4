import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:test4/hive/postsave.dart';
import 'package:test4/modal/post.dart';

import '../screen/post_details.dart';
import '../helper/constants.dart';

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
                var title = postSaveBox.getAt(index)?.title;
                var catName = postSaveBox.getAt(index)?.catName;
                var content = postSaveBox.getAt(index)?.content;
                var date = postSaveBox.getAt(index)?.date;
                var thumbnailSmall = postSaveBox.getAt(index)?.thumbnailSmall;
                var thumbnailFull = postSaveBox.getAt(index)?.thumbnailFull;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostDetailsWithThumbnail(
                                PostObj: Post(
                                    id: postSaveBox.getAt(index)?.key,
                                    title: title,
                                    content: content,
                                    date: date,
                                    thumbnailSmall: thumbnailSmall,
                                    thumbnailFull: thumbnailFull,
                                    catName: catName),
                              )),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  thumbnailFull ?? Constants.defaultImageUrl,
                                  height: 80.0,
                                  width: 120.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Html(
                                      data: title,
                                      style: {
                                        '#': Style(
                                          color: Colors.black,
                                          fontSize: FontSize.large,
                                          maxLines: 2,
                                          textOverflow: TextOverflow.ellipsis,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                        ),
                                      },
                                    ),
                                    Html(
                                      data: date?.substring(0, 10),
                                      style: {
                                        '#': Style(
                                          color:
                                              Color.fromARGB(255, 65, 65, 65),
                                          maxLines: 1,
                                          fontSize: FontSize(13),
                                          textOverflow: TextOverflow.ellipsis,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                        ),
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              children: [
                                LikeButton(
                                  isLiked: postSaveBox.keys
                                      .contains(postSaveBox.getAt(index)?.key),
                                  onTap: (isLiked) async {
                                    if (isLiked) {
                                      postSaveBox.delete(
                                          postSaveBox.getAt(index)?.key);
                                    } else {
                                      PostSave postSave = PostSave();
                                      postSave.title = title ?? "";
                                      postSave.content = content ?? "";
                                      postSave.date = date ?? "";
                                      postSave.thumbnailSmall =
                                          thumbnailSmall ?? "";
                                      postSave.thumbnailFull =
                                          thumbnailFull ?? "";
                                      postSave.catName = catName ?? "";

                                      postSaveBox.put(
                                          postSaveBox.getAt(index)?.key,
                                          postSave);
                                    }

                                    return !isLiked;
                                  },
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Colors.orange),
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 3, 10, 0),
                                  child: Text(
                                    catName ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}
