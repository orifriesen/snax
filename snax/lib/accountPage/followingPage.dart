import 'package:flutter/material.dart';
import 'package:snax/backend/requests.dart';

class FollowingPage extends StatefulWidget {
  String uid;
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: FutureBuilder(
        future: SnaxBackend.getFollowing(this.widget.uid),
        builder: (context, index) {
          if (index.connectionState == ConnectionState.done) {
            return ListView(
              children: [
                Container(
                  child: Text("${SnaxBackend.currentUser.name}"),
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      // body: postFollowing(this.widget.uid),
    );
  }
}
