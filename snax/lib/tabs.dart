import 'package:flutter/material.dart';
import 'package:snax/accountPage/accountPage.dart';
import 'package:snax/feedPage/FeedPage.dart';
import 'package:snax/homePage/homePage.dart';

class AppTabs extends StatefulWidget {
  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: "Feed",
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profile")
          ],
          showUnselectedLabels: false,
        ),
        body: [
          DefaultTabController(length: 2, child: MainPage()),
          Feed(),
          AccountPage()
        ][_currentIndex],
      ),
    );
  }
}

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  @override
  Widget build(BuildContext context) {
    return FeedPage();
  }

  @override
  bool get wantKeepAlive => true;
}
