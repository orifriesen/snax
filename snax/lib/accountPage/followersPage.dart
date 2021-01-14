import 'package:flutter/material.dart';

import 'package:snax/accountPage/globalAccountPage.dart';

import 'package:snax/feedPage/post.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';
import 'package:sup/quick_sup.dart';

class FollowersPage extends StatefulWidget {
  SnaxUser user;
  String uid;
  FollowersPage(this.uid, this.user);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  void initState() {
    super.initState();
    this.isFollowing = this.widget.user.userIsFollowing;
  }

  bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: FutureBuilder(
          future: SnaxBackend.getFollowers(this.widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (this.widget.user.followerCount == 0) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24, top: 75, right: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "No Followers",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            Text(
                              "@" +
                                  this.widget.user.username +
                                  " has no followers",
                            ),
                            Text("Be the first the follow!")
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].username),
                      subtitle: Text(snapshot.data[index].name),
                      leading: CircleAvatar(
                          backgroundImage:
                              //! NOT RIGHT -- Escher will fix this
                              NetworkImage(SnaxBackend.currentUser.photo)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                //! NOT RIGHT -- Leads to current user's profile
                                GlobalAccountPage(this.widget.user),
                          ),
                        );
                      },
                      trailing: FlatButton(
                        onPressed: () {},
                        height: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: this.isFollowing
                                  ? Colors.grey[600]
                                  : Colors.transparent),
                        ),
                        child: Text(
                          () {
                            if (this.isFollowing) {
                              print("followed: ${this.widget.user.name}");
                              return "Unfollow";
                            } else {
                              print("unfollowed: ${this.widget.user.name}");
                              return "Follow";
                            }
                          }(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: this.isFollowing
                            ? Colors.transparent
                            : SnaxColors.redAccent,
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
