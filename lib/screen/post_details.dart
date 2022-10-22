import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:like_button/like_button.dart';
import 'package:test4/helper/constants.dart';
import 'package:test4/modal/post.dart';

class PostDetailsWithThumbnail extends StatefulWidget {
  final Post PostObj;
  const PostDetailsWithThumbnail({
    Key? key,
    required this.PostObj,
  }) : super(
          key: key,
        );

  @override
  State<PostDetailsWithThumbnail> createState() =>
      _PostDetailsWithThumbnailState();
}

class _PostDetailsWithThumbnailState extends State<PostDetailsWithThumbnail> {
  Color _loveButtonColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    Post postObj = widget.PostObj;

    return Scaffold(
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        SliverAppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.20),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  splashRadius: 23,
                  icon: Icon(Icons.favorite, color: _loveButtonColor, size: 20),
                  onPressed: () {
                    setState(() {
                      _loveButtonColor = Colors.red;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.20),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  splashRadius: 23,
                  icon: Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          expandedHeight: 300.0,
          collapsedHeight: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top,
          elevation: 0.0,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              postObj.thumbnailFull ?? Constants.defaultImageUrl,
              fit: BoxFit.cover,
            ),
            stretchModes: const [
              StretchMode.zoomBackground,
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              child: Container(
                width: 40.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.red,
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    48,
                  ),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Html(
                      data: postObj.title,
                      style: {
                        "body": Style(
                          fontSize: FontSize(22.0),
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_month,
                        ),
                        Text((postObj.date ?? "2022-09-21").substring(0, 10)),
                      ],
                    ),
                  ),
                  // renderAudioWidget(blogData, context),
                  Html(
                    data: postObj.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(18.0),
                      ),
                    },
                  )
                ],
              ),
            ),
          ),
        ]))
      ]),
    );
  }
}
