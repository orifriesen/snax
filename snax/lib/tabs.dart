import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/feedPage.dart';
import 'package:snax/homePage/homePage.dart';
import 'package:snax/activityPage/activityPage.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/themes.dart';

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
          bottomNavigationBar: SafeArea(
            bottom: false,
            child: GNav(
                haptic: true,
                tabBorderRadius: 20,
                curve: Curves.easeOutExpo,
                duration: Duration(milliseconds: 500),
                gap: 4,
                tabMargin: EdgeInsets.all(4),
                color: isDark(context) == true ? Colors.white : Colors.black,
                activeColor: getTheme(context).primaryContrastForText(),
                iconSize: 20,
                tabBackgroundColor: getTheme(context).accentColor,
                backgroundColor: isDark(context) == true
                    ? SnaxColors.darkGreyGradientEnd
                    : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                tabs: [
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home',
                  ),
                  GButton(icon: Icons.chat_rounded, text: 'Feed'),
                  GButton(
                    icon: Icons.add_circle_outline_rounded,
                    iconSize: 22,
                    onPressed: () {
                      print("test");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MakePostPage()));
                    },
                  ),
                  GButton(
                    icon: Icons.inbox_rounded,
                    text: 'Activity',
                  ),
                  GButton(
                    leading: CircleAvatar(
                        radius: 14,
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                                placeholder: "assets/blank_user.png",
                                image: userImageURL(
                                    SnaxBackend.currentUser != null
                                        ? SnaxBackend.currentUser.uid
                                        : "")))),
                    text: 'Profile',
                  )
                ],
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  index == 2
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MakePostPage()))
                      : setState(() {
                          _currentIndex = index;
                        });
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: 54),
            child: [
              DefaultTabController(
                  length: 2,
                  child: MainPage(),
                  key: PageStorageKey("home_key")),
              FeedPage(),
              Container(),
              ActivityPage(),
              GlobalAccountPage(SnaxBackend.currentUser, isAccountPage: true)
            ][_currentIndex],
          ),
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
