import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:like_button/like_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:test4/screen/post_details.dart';
import 'package:test4/views/shimmer_layout.dart';

import '../helper/constants.dart';
import '../modal/post.dart';
import 'package:http/http.dart' as http;
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostListView extends StatefulWidget {
  const PostListView({super.key});

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView>
    with AutomaticKeepAliveClientMixin {
  final _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  List<Post> posts = [];
  late String loadingUrl;
  String? catId;
  bool loading = false;
  bool hasMorePosts = true;
  bool showShimmer = true;
  int pageNo = 1;

  @override
  void initState() {
    if (catId != null) {
      loadingUrl = "${Constants.baseRestUrl}posts?categories=$catId&";
    } else {
      loadingUrl = "${Constants.baseRestUrl}posts?";
    }

    variableReset();
    loadRestApi();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          if (hasMorePosts && !loading) {
            setState(() {
              pageNo++;
              loadRestApi();
            });
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        if (posts.length > 20) {
          Dialogs.materialDialog(
            msg: 'Are you sure ? everything will reload again',
            title: "Reload",
            color: Colors.white,
            context: context,
            actions: [
              IconsOutlineButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                text: 'Cancel',
                iconData: Icons.cancel_outlined,
                textStyle: TextStyle(color: Colors.grey),
                iconColor: Colors.grey,
              ),
              IconsButton(
                onPressed: () async {
                  Navigator.pop(context);
                  variableReset();
                  await loadRestApi();
                },
                text: 'Reload',
                iconData: Icons.refresh,
                color: Colors.red,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ],
          );
        } else {
          variableReset();
          await loadRestApi();
        }
        print("onrefresh");
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: getPostsLength(posts),
        itemBuilder: (context, index) {
          if (showShimmer) {
            return ShimmerLyoutPostList();
          }

          if (index == posts.length) {
            if (hasMorePosts) {
              return const Card(
                  child: Padding(
                padding: EdgeInsets.all(5.0),
                child: SpinKitThreeBounce(
                  color: Colors.pink,
                  size: 50,
                ),
              ));
            } else {
              return Text("no more posts");
            }
          }

          var title = posts[index].title;
          var thumbnail = posts[index].thumbnail;
          var agoTime = posts[index].agoTime;
          var catName = posts[index].catName;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetails(
                          myPostObj: posts[index],
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
                            thumbnail ?? Constants.defaultImageUrl,
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
                                data: agoTime,
                                style: {
                                  '#': Style(
                                    color: Color.fromARGB(255, 65, 65, 65),
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
                          LikeButton(),
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.orange),
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
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
        },
      ),
    );
  }

  void variableReset() {
    setState(() {
      showShimmer = true;
      pageNo = 1;
      hasMorePosts = true;
      loading = false;
      posts.clear();
    });
  }

  loadRestApi() async {
    loading = true;
    try {
      var response =
          await http.get(Uri.parse("${loadingUrl}per_page=20&page=$pageNo"));
      if (response.statusCode == 200) {
        setState(() {
          showShimmer = false;
        });
        print("got response");
        loading = false;
        var jsonArray = json.decode(response.body);
        for (var i = 0; i < jsonArray.length; i++) {
          setState(() {
            posts.add(Post.fromJson(jsonArray[i]));
          });
        }
      } else if (response.statusCode == 400) {
        gotAnError(null);
      } else {
        gotAnError("got an error ${response.statusCode}");
      }
    } on SocketException {
      gotAnError('No Internet connection 😑');
    } on HttpException {
      gotAnError("Couldn't find the post 😱");
    } on FormatException {
      gotAnError("Bad response format 👎");
    } catch (e) {
      gotAnError(e.toString());
    }
  }

  void gotAnError(String? msg) {
    setState(() {
      showShimmer = false;
      loading = false;
      hasMorePosts = false;
    });
    if (msg != null) {
      Dialogs.materialDialog(
        msg: msg,
        title: "Error!",
        color: Colors.white,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () async {
              Navigator.pop(context);
              variableReset();
              await loadRestApi();
            },
            text: 'Reload',
            iconData: Icons.refresh,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    }
  }

  int getPostsLength(List<Post> posts) {
    if (showShimmer) {
      return 10;
    } else {
      return posts.length + 1;
    }
  }
}
