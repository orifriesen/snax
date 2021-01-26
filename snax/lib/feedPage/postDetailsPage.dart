import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
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
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        brightness: Brightness.dark,
      ),
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
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: postWidget(context, widget.post, opensDetails: false),
            ),
          ),
        ]),
        commentLoader(context, widget.post),
      ]),
      bottomSheet: TextField(
        textInputAction: TextInputAction.send,
        controller: commentController,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            hintText: "Add Comment...", contentPadding: EdgeInsets.all(16.0)),
        onEditingComplete: () {
          widget.post.comment(commentController.text).then((Comment comment) {
            //Find the index of the temp comment and replace it
            var tempIndex =
                widget.post.comments.indexWhere((e) => e.id == 'temp-cmt-id');
            if (tempIndex > 0)
              setState(() {
                widget.post.comments[tempIndex] = comment;
              });
            print("Sent Comment");
          }).catchError((error) {
            print("Error");
            Fluttertoast.showToast(msg: "An error occurred");
            //Remove temp comment
            var tempIndex =
                widget.post.comments.indexWhere((e) => e.id == 'temp-cmt-id');
            if (tempIndex > 0)
              setState(() {
                widget.post.comments.removeAt(tempIndex);
              });
          });
          var tempComment = Comment(
              "temp-cmt-id",
              this.widget.post.id,
              SnaxBackend.currentUser,
              commentController.text,
              DateTime.now(),
              0);
          setState(() {
            widget.post.comments.insert(0, tempComment);
            widget.post.commentCount++;
            commentController.clear();
            FocusScope.of(context).unfocus();
          });
        },
      ),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GlobalAccountPage(comment.user),
                              ),
                            );
                          },
                          child: CircleAvatar(
                              backgroundImage: (comment.user.photo != null)
                                  ? NetworkImage(comment.user.photo)
                                  : AssetImage("assets/blank_user.png")),
                        ),
                      ),
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                              TextSpan(
                                  text: comment.user.name + "\n",
                                  style: TextStyle(
                                      height: 2, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GlobalAccountPage(comment.user),
                                        ),
                                      );
                                    }),
                              TextSpan(text: comment.body),
                              TextSpan(
                                  text: " " + dateFormatComment(comment.time),
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
                        isLiked: comment.likedByMe,
                        key: Key('${widget.post.id}${comment.id}'),
                        likeCount: (comment.likes > 0) ? comment.likes : null,
                        countPostion: CountPostion.left,
                        onTap: (isLiked) async {
                          comment.like(!isLiked);
                          setState(() {});
                          return !isLiked;
                        },
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

  Widget commentLoader(BuildContext context, Post post) {
    if (post.comments != null)
      return getPostDetails(context, post);
    else
      return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            post.comments = snapshot.data; // delete once comments load
            return getPostDetails(context, post);
          } else if (snapshot.hasError)
            return Center(
              child: Text("Failed to load post."),
            );
          else
            return Expanded(
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            SnaxColors.redAccent))));
        },
        future: post.getComments(),
      );
  }
}
