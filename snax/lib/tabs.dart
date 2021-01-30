import 'package:flutter/material.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/FeedPage.dart';
import 'package:snax/homePage/homePage.dart';
import 'package:snax/activityPage/activityPage.dart';

import 'helpers.dart';

class AppTabs extends StatefulWidget {
  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs>
    with AutomaticKeepAliveClientMixin<AppTabs> {
  int _currentIndex = 0;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  bool get wantKeepAlive => true;

  void onTabTapped(int index) async {
    try {
      if (index == 3) await SnaxBackend.auth.loginIfNotAlready();

      setState(() {
        _currentIndex = index;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageStorage(
      bucket: bucket,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: _currentIndex == 0
                          ? Icon(Icons.home_rounded)
                          : Icon(Icons.home_outlined),
                      onPressed: () {}),
                  IconButton(
                      icon: _currentIndex == 1
                          ? Icon(Icons.chat_rounded)
                          : Icon(Icons.chat_outlined),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.inbox_outlined),
                      onPressed: () {
                        _currentIndex = 1;
                      }),
                  IconButton(
                      icon: Icon(Icons.person_outlined), onPressed: () {})
                ]),
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            /*items: [
              new BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? Icon(Icons.home_rounded, color: SnaxColors.redAccent)
                    : Icon(Icons.home_outlined, color: SnaxColors.subtext),
                label: "Home",
              ),
              new BottomNavigationBarItem(
                icon: _currentIndex == 1
                    ? Icon(Icons.chat_rounded, color: SnaxColors.redAccent)
                    : Icon(Icons.chat_outlined, color: SnaxColors.subtext),
                label: "Feed",
              ),
              new BottomNavigationBarItem(
                  icon: _currentIndex == 2
                      ? Icon(Icons.inbox, color: SnaxColors.redAccent)
                      : Icon(Icons.inbox_outlined, color: SnaxColors.subtext),
                  label: "Activity"),
              new BottomNavigationBarItem(
                icon: _currentIndex == 3
                    ? Icon(Icons.person, color: SnaxColors.redAccent)
                    : Icon(Icons.person_outline, color: SnaxColors.subtext),
                label: "Profile",
              )
            ],*/
          ),
          body: [
            DefaultTabController(
                length: 2, child: MainPage(), key: PageStorageKey("home_key")),
            FeedPage(),
            ActivityPage(),
            GlobalAccountPage(SnaxBackend.currentUser, isAccountPage: true)
          ][_currentIndex],
        ),
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
