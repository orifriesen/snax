import 'package:flutter/material.dart';
import 'package:snax/accountPage/accountPage.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/FeedPage.dart';
import 'package:snax/homePage/homePage.dart';

class AppTabs extends StatefulWidget {
  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  int _currentIndex = 0;

  void onTabTapped(int index) async {
    try {
      if (index == 2) await SnaxBackend.auth.loginIfNotAlready();

      setState(() {
        _currentIndex = index;
      });
    } catch (error) {}
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
              icon: _currentIndex == 0
                  ? Icon(Icons.home_rounded)
                  : Icon(Icons.home_outlined),
              label: "Home",
            ),
            new BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(Icons.chat_rounded)
                  : Icon(Icons.chat_outlined),
              label: "Feed",
            ),
            new BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outline),
              label: "Profile",
            )
          ],
          showUnselectedLabels: false,
        ),
        body: [
          DefaultTabController(length: 2, child: MainPage()),
          FeedPage(),
          AccountPage()
        ][_currentIndex],
      ),
    );
  }
}
