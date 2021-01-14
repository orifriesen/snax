import 'package:flutter/material.dart';

import 'package:snax/accountPage/globalAccountPage.dart';

import 'package:snax/feedPage/post.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';
import 'package:sup/quick_sup.dart';

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
        title: Text(this.widget.pageTitle),
        brightness: Brightness.dark,
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
                    print(user.userIsFollowing);
                    return ListTile(
                      title: Text(snapshot.data[index].username),
                      leading: CircleAvatar(
                          backgroundImage:
                              //! NOT RIGHT -- Escher will fix this
                              (user.photo != null)
                                  ? NetworkImage(user.photo)
                                  : AssetImage("assets/blank_user.png")),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                //! NOT RIGHT -- Leads to current user's profile
                                GlobalAccountPage(user),
                          ),
                        );
                      },
                      trailing: FlatButton(
                        onPressed: () {
                          //! This whole section only works when following
                          //! Changes/Updates all the users rather than one
                          // if (this.widget.user.userIsFollowing) {
                          //   this.widget.user.unfollow().catchError((_) {
                          //     //Unfollow Failed, reset isFollowing
                          //     this.isFollowing = true;
                          //     this.widget.user.followerCount++;
                          //   });
                          //   this.isFollowing = false;
                          //   this.widget.user.followerCount--;
                          // } else {
                          //   this.widget.user.follow().catchError((_) {
                          //     this.isFollowing = false;
                          //     this.widget.user.followerCount++;
                          //   });
                          //   this.isFollowing = true;
                          //   this.widget.user.followerCount++;
                          // }
                          // this.setState(() {});
                        },
                        height: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: user.userIsFollowing
                                  ? SnaxColors.subtext
                                  : Colors.transparent),
                        ),
                        child: Text(
                          () {
                            if (user.userIsFollowing) {
                              return "Unfollow";
                            } else {
                              return "Follow";
                            }
                          }(),
                          style: TextStyle(
                            color: SnaxColors.subtext,
                          ),
                        ),
                        color: user.userIsFollowing
                            ? Colors.transparent
                            : SnaxColors.redAccent,
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
