import 'package:flutter/material.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/feedPage/post.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feed"),
          actions: [
            IconButton(
                icon: Icon(Icons.add_comment_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MakePostPage()));
                })
          ],
        ),
        body: getFeed(context, DemoValues.demoPosts));
  }
}

Widget getFeed(BuildContext context, List<Post> demoPost) {
  final List<Post> demoPosts = demoPost;
  print(demoPosts.length);
  return ListView.builder(
    itemCount: demoPosts.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Card(
          child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(demoPosts[index].snack.image)),
                      ),
                      title: Text(demoPosts[index].snack.name),
                      subtitle: Text(demoPosts[index].user.name),
                    ),
                    Text(
                      demoPosts[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(demoPosts[index].body),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      leading: FittedBox(child: LikeButton(
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite,
                            color: isLiked
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                            size: 20.0,
                          );
                        },
                      )),
                      trailing: Text(
                          DateFormat("MMM dd").format(demoPosts[index].time)),
                    )
                  ])),
        ),
      );
    },
  );
}
