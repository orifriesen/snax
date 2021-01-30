import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/feedPage/post.dart';
import 'package:snax/helpers.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with AutomaticKeepAliveClientMixin<ActivityPage> {
  @override
  bool get wantKeepAlive => true;

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isScrolled) => [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  centerTitle: true,
                  leadingWidth: double.infinity,
                  leading: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 16.0),
                      child: Text("Activity",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 75, 43),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ))),
                  actions: [],
                ),
              ],
          body: Column(
            children: [
              likedComment(),
              likedPost(),
              followed(),
              commentOnPost(),
              mention()
            ],
          )),
    );
  }
}

Widget likedComment() {
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
                onTap: () {},
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/blank_user.png")),
              ),
            ),
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "escher",
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                TextSpan(
                    text: " liked your comment",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
                TextSpan(
                    text: " " + "2d",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.5,
                        color: SnaxColors.subtext))
              ])),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget likedPost() {
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
                onTap: () {},
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/blank_user.png")),
              ),
            ),
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "escher",
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                TextSpan(
                    text: " liked your post",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
                TextSpan(
                    text: " " + "2d",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.5,
                        color: SnaxColors.subtext))
              ])),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget followed() {
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
                onTap: () {},
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/blank_user.png")),
              ),
            ),
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "escher",
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                TextSpan(
                    text: " started following you",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
                TextSpan(
                    text: " " + "2d",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.5,
                        color: SnaxColors.subtext))
              ])),
            ),
            FlatButton(
              onPressed: () {},
              height: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.transparent),
              ),
              child: Text(
                "Follow",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: SnaxColors.redAccent,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget commentOnPost() {
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
                onTap: () {},
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/blank_user.png")),
              ),
            ),
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "escher",
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                TextSpan(
                    text:
                        " commented on your post: haha this is so funny and so relatable. You are so cool.",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
                TextSpan(
                    text: " " + "2d",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.5,
                        color: SnaxColors.subtext))
              ])),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget mention() {
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
                onTap: () {},
                child: CircleAvatar(
                    backgroundImage: AssetImage("assets/blank_user.png")),
              ),
            ),
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "escher",
                    style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                TextSpan(
                    text:
                        " mentioned you in a comment: @ori literally me. Im actually dying",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
                TextSpan(
                    text: " " + "2d",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.5,
                        color: SnaxColors.subtext))
              ])),
            ),
          ],
        ),
      ],
    ),
  );
}
