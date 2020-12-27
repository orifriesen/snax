import 'package:flutter/material.dart';

import 'package:snax/accountPage/followersPage.dart';
import 'package:snax/accountPage/followingPage.dart';
import 'package:snax/accountPage/settingsPage.dart';

import 'editProfile.dart';
import 'accountBottomTabs/postTab.dart';
import 'accountBottomTabs/secondTab.dart';

import 'package:snax/backend/requests.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/helpers.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  Color burningOrangeStart = const Color.fromRGBO(255, 65, 108, 1.0);
  Color burningOrangeEnd = const Color.fromRGBO(255, 75, 43, 1.0);

  bool bioShowTextFlag = true;

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    _tabController.addListener(handleTabSelection);
  }

  handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: burningOrangeEnd,
        title: Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()))
            },
          )
        ],
      ),
      body: (SnaxBackend.currentUser == null)
          ? Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ready to Start Sharing?\n",
                  style: TextStyle(fontSize: 17),
                ),
                MaterialButton(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login, color: Colors.white),
                        Padding(padding: EdgeInsets.only(left: 16)),
                        Text("Sign In",
                            style: TextStyle(fontSize: 15, color: Colors.white))
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: SnaxColors.redAccent,
                  onPressed: () {
                    SnaxBackend.auth.loginIfNotAlready().then((_) {
                      setState(() {});
                    }).catchError((err) {});
                  },
                )
              ],
            ))
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(60, 0, 0, 0), blurRadius: 12)
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    gradient: SnaxGradients.redBigThings,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          _profileInfo(),
                          SizedBox(height: 10),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: _profileBio()),
                          SizedBox(height: 10),
                          _profileStats(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: SnaxColors.redAccent,
                        labelColor:
                            !isDark(context) ? Colors.black : Colors.white,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            text: 'Posts',
                          ),
                          Tab(
                            text: 'Reviewed',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                [
                  PostTab(),
                  ReviewedTab(),
                ][_tabController.index],
              ],
            ),
    );
  }

//* This is the users profile picture, username, and handle
  Widget _profileInfo() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(SnaxBackend.currentUser.photo == null
                    ? 'https://picsum.photos/200/300?grayscale'
                    : SnaxBackend.currentUser.photo),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SnaxBackend.currentUser.name,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              SnaxBackend.currentUser.username,
              style: TextStyle(fontSize: 15, color: Colors.grey[300]),
            ),
          ],
        ),
      ],
    );
  }

//* This displays the users bio
  Widget _profileBio() {
    final bioText = "${SnaxBackend.currentUser.bio}";
    final numLines = '\n'.allMatches(bioText).length + 1;
    var _maxLines = bioShowTextFlag ? 4 : 8;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          children: [
            (SnaxBackend.currentUser.bio != null)
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bioText,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          maxLines: _maxLines,
                        ),
                        numLines >= 4
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    bioShowTextFlag = !bioShowTextFlag;
                                  });
                                  print(numLines);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    bioShowTextFlag
                                        ? Text(
                                            "more",
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //* This is for the following, followers, and EP
  Widget _profileStats() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //* Following
          Column(
            children: [
              FlatButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FollowingPage())),
                },
                child: _following(),
              ),
            ],
          ),
          //* Followers
          Column(
            children: [
              FlatButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FollowersPage())),
                },
                child: _followers(),
              )
            ],
          ),
          //* Edit Profile
          Column(
            children: [
              Container(
                child: RaisedButton(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.white, width: 2),
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(),
                      ),
                    ).whenComplete(
                      () => setState(() {}),
                    ),
                  },
                  child: Text('Edit Profile',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //* This groups the text for the following button
  //* It will allow the user to see who they follow
  Widget _following() {
    return Column(
      children: [
        Text(
          '${SnaxBackend.currentUser.followingCount}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Following',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  //* This groups the text for the followers button
  //* It will allow the user to view their followers
  Widget _followers() {
    return Column(
      children: [
        Text(
          '${SnaxBackend.currentUser.followerCount}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Followers',
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
