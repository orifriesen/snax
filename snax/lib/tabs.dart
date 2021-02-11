import 'package:flutter/material.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/feedPage.dart';
import 'package:snax/homePage/homePage.dart';
import 'package:snax/activityPage/activityPage.dart';
import 'package:snax/feedPage/makePostPage.dart';

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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MakePostPage(),
                  fullscreenDialog: true));
            },
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
                      color: _currentIndex == 0
                          ? Theme.of(context).accentColor
                          : Theme.of(context).bottomAppBarTheme.color,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      }),
                  IconButton(
                      icon: _currentIndex == 1
                          ? Icon(Icons.chat_rounded)
                          : Icon(Icons.chat_outlined),
                      color: _currentIndex == 1
                          ? Theme.of(context).accentColor
                          : Theme.of(context).bottomAppBarTheme.color,
                      onPressed: () {
                        if (_currentIndex == 1) feedTop.add(null);
                        setState(() {
                          _currentIndex = 1;
                        });
                      }),
                  Container(height: 20, width: 20),
                  IconButton(
                      icon: Icon(_currentIndex == 2
                          ? Icons.inbox
                          : Icons.inbox_outlined),
                      color: _currentIndex == 2
                          ? Theme.of(context).accentColor
                          : Theme.of(context).bottomAppBarTheme.color,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      }),
                  IconButton(
                      icon: Icon(_currentIndex == 3
                          ? Icons.person
                          : Icons.person_outlined),
                      color: _currentIndex == 3
                          ? Theme.of(context).accentColor
                          : Theme.of(context).bottomAppBarTheme.color,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 3;
                        });
                      })
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
