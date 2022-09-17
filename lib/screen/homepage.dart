import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:test4/views/category_list.dart';

import '../views/post_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          _controller.jumpToPage(0);
          return false;
        }

        Dialogs.materialDialog(
          msg: "Do you want to exit the app?",
          title: "Exit!",
          color: Colors.white,
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Cancel',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
            ),
            IconsButton(
              onPressed: () {
                Navigator.pop(context);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              text: 'Exit',
              iconData: Icons.exit_to_app,
              color: Colors.red,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Homepage"),
        ),
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          onPageChanged: (currentPageNumber) {
            setState(() {
              _currentIndex = currentPageNumber;
            });
          },
          children: const [
            PostListView(),
            CategoryList(),
            Text("Search"),
            Text("Bookmark"),
            Text("Profile"),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "category",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "Bookmark",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "User",
            ),
          ],
          onTap: (value) {
            _controller.jumpToPage(
              value,
            );
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
