import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/feedPage.dart';
import 'package:snax/feedPage/post.dart';
import 'package:intl/intl.dart';
import 'package:snax/helpers.dart';

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
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Column(children: [
        Stack(children: [
          Container(
              child: SafeArea(
                  left: false,
                  right: false,
                  bottom: false,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                  )),
              decoration: BoxDecoration(
                  color: SnaxColors.redAccent,
                  gradient: SnaxGradients.redBigThings,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)))),
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 8.0),
            child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                iconSize: 28,
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 76.0),
            child: postWidget(context, widget.post, opensDetails: false),
          ),
        ]),
        commentLoader(context, widget.post),
      ]),
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
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: post.comments.length + 1,
      itemBuilder: (context, index) {
        Comment comment;
        index < post.comments.length
            ? comment = post.comments[index]
            : comment = null;
        if (index == post.comments.length) {
          return Container(height: 200);
        } else {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
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
                                text: " " + dateFormatComment(post.time),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 11.5))
                          ])),
                    ),
                    FittedBox(
                        child: LikeButton(
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked
                              ? Theme.of(context).accentColor
                              : Colors.grey[350],
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
    ),
  );
}
