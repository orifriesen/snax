import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/post.dart';
import 'package:intl/intl.dart';

class PostDetailsPage extends StatefulWidget {
  final Post post;
  const PostDetailsPage({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  _PostDetailsPage createState() => _PostDetailsPage();
}

class _PostDetailsPage extends State<PostDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: commentLoader(context, widget.post),
      bottomSheet: TextField(
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: "Add Comment...", contentPadding: EdgeInsets.all(16.0)),
      ),
    );
  }
}

Widget commentLoader(BuildContext context, Post post) {
  if (post.comments != null)
    return getPostDetails(context, post);
  else
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          post.comments = DemoValues.demoComments; // delete once comments load
          return getPostDetails(context, post);
        } else if (snapshot.hasError)
          return Center(
            child: Text("Failed to load post."),
          );
        else
          return Center(child: CircularProgressIndicator());
      },
      future: SnaxBackend.search("Cheetos"),
    );
}

Widget getPostDetails(BuildContext context, Post post) {
  return ListView.builder(
    itemCount: post.comments.length + 2,
    itemBuilder: (context, index) {
      Comment comment;
      (index != 0 && index != post.comments.length + 1)
          ? comment = post.comments[index - 1]
          : comment = null;
      if (index == 0) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                visualDensity: VisualDensity.comfortable,
                leading: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(
                      post.snack.image,
                      scale: 4,
                    )),
                title: Text(post.snack.name),
                subtitle: Text(post.user.name),
              ),
              Text(
                post.title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(post.body),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                leading: FittedBox(
                    child: LikeButton(
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color:
                          isLiked ? Theme.of(context).accentColor : Colors.grey,
                      size: 20.0,
                    );
                  },
                  likeCount: post.likeCount,
                )),
                trailing: Text(DateFormat("MMM dd").format(post.time)),
              ),
              Divider(
                thickness: 2,
              )
            ],
          ),
        );
      } else if (index == post.comments.length + 1) {
        return Container(height: 200);
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text(comment.user.name),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                          TextSpan(
                              text: comment.user.name + "\n",
                              style: TextStyle(height: 2)),
                          TextSpan(text: comment.body),
                          TextSpan(
                              text: DateFormat(" MMM dd").format(post.time),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 11.5))
                        ])),
                  ),
                  FittedBox(
                      child: LikeButton(
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                        size: 20.0,
                      );
                    },
                    likeCount: (comment.likes > 0) ? comment.likes : null,
                    countPostion: CountPostion.left,
                  )),
                ],
              ),
            ],
          ),
        );
      }
    },
  );
}
