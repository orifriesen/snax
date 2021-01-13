import 'package:flutter/material.dart';

import 'package:snax/accountPage/globalAccountPage.dart';

import 'package:snax/feedPage/post.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';

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
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].username),
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
                    onPressed: () {
                      //! This whole section only works when following
                      //! Changes/Updates all the users rather than one
                      if (this.widget.user.userIsFollowing) {
                        this.widget.user.unfollow().catchError((_) {
                          //Unfollow Failed, reset isFollowing
                          this.isFollowing = true;
                          this.widget.user.followerCount++;
                        });
                        this.isFollowing = false;
                        this.widget.user.followerCount--;
                      } else {
                        this.widget.user.follow().catchError((_) {
                          this.isFollowing = false;
                          this.widget.user.followerCount++;
                        });
                        this.isFollowing = true;
                        this.widget.user.followerCount++;
                      }
                      this.setState(() {});
                    },
                    height: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: this.isFollowing
                              ? Colors.grey
                              : Colors.transparent),
                    ),
                    child: Text(
                      () {
                        if (this.isFollowing) {
                          return "Unfollow";
                        } else {
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
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
