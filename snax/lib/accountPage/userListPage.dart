import 'package:flutter/material.dart';

import 'package:snax/accountPage/globalAccountPage.dart';

import 'package:snax/feedPage/post.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';
import 'package:sup/quick_sup.dart';

import '../themes.dart';

class UserListPage extends StatefulWidget {
  Future fetcher;
  String pageTitle;
  UserListPage(this.pageTitle, this.fetcher);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.pageTitle,
            style: TextStyle(color: getTheme(context).appBarContrastForText())),
        brightness: getTheme(context).appBarBrightness(),
      ),
      body: FutureBuilder(
          future: this.widget.fetcher,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.only(top: 16),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    SnaxUser user = snapshot.data[index];
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text("@" + snapshot.data[index].username),
                      leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: (user.photo != null)
                              ? NetworkImage(user.photo)
                              : AssetImage("assets/blank_user.png")),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GlobalAccountPage(user),
                          ),
                        );
                      },
                      trailing: user.uid != SnaxBackend.currentUser.uid
                          ? FlatButton(
                              onPressed: () {
                                if (user.userIsFollowing) {
                                  user.unfollow().catchError((_) {
                                    //Unfollow Failed, reset isFollowing
                                    user.userIsFollowing = true;
                                    user.followerCount++;
                                  });
                                  user.userIsFollowing = false;
                                  user.followerCount--;
                                } else {
                                  user.follow().catchError((_) {
                                    user.userIsFollowing = false;
                                    user.followerCount++;
                                  });
                                  user.userIsFollowing = true;
                                  user.followerCount++;
                                }
                                this.setState(() {});
                              },
                              height: 30,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: user.userIsFollowing
                                      ? Colors.grey
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(() {
                                if (user.userIsFollowing) {
                                  return "Unfollow";
                                } else {
                                  return "Follow";
                                }
                              }(),
                                  style: TextStyle(
                                      color: user.userIsFollowing
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color
                                          : getTheme(context)
                                              .accentContrastForText())),
                              color: user.userIsFollowing
                                  ? Colors.transparent
                                  : getTheme(context).accentColor,
                            )
                          : Container(child: Text("")),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
