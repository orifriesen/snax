import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';

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
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("working");
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data[index].username);
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
