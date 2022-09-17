import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:test4/modal/category.dart';
import 'package:test4/views/shimmer_layout.dart';

import '../helper/constants.dart';
import 'package:http/http.dart' as http;
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>
    with AutomaticKeepAliveClientMixin {
  final _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  List<Category> categories = [];
  late String loadingUrl;
  bool loading = false;
  bool hasMorePosts = true;
  bool showShimmer = true;
  int pageNo = 1;

  @override
  void initState() {
    loadingUrl = "${Constants.baseRestUrl}categories?";

    variableReset();
    loadRestApi();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          print("bottom");
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
        if (categories.length > 10) {
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
        itemCount: getPostsLength(categories),
        itemBuilder: (context, index) {
          if (showShimmer) {
            return const ShimmerLayoutCategoryList();
          }

          if (index == categories.length) {
            if (hasMorePosts) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: SpinKitThreeBounce(
                    color: Colors.pink,
                    size: 50,
                  ),
                ),
              );
            } else {
              return Text("no more posts a");
            }
          }

          var title = categories[index].title;
          var thumbnail = categories[index].thumbnail;

          return InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                        image: NetworkImage(
                          Constants.defaultImageUrl,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          title ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
      categories.clear();
    });
  }

  loadRestApi() async {
    loading = true;
    try {
      var response =
          await http.get(Uri.parse("${loadingUrl}per_page=100&page=$pageNo"));
      if (response.statusCode == 200) {
        setState(() {
          showShimmer = false;
        });
        print("got response");
        loading = false;
        var jsonArray = json.decode(response.body);
        for (var i = 0; i < jsonArray.length; i++) {
          setState(() {
            categories.add(Category.fromJson(jsonArray[i]));
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

  int getPostsLength(List<Category> categories) {
    if (showShimmer) {
      return 10;
    } else {
      return categories.length;
    }
  }
}
