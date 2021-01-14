import 'package:flutter/material.dart';

import 'package:snax/accountPage/globalAccountPage.dart';

import 'package:snax/feedPage/post.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';

class FollowingPage extends StatefulWidget {
  SnaxUser user;
  String uid;
  FollowingPage(this.uid, this.user);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
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
        title: Text('Following'),
      ),
      body: FutureBuilder(
        future: SnaxBackend.getFollowing(this.widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
