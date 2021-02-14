import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/generated/i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/feedPage/post.dart';
import 'package:snax/feedPage/postDetailsPage.dart';
import 'package:snax/helpers.dart';
import 'package:snax/themes.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with AutomaticKeepAliveClientMixin<ActivityPage> {
  @override
  bool get wantKeepAlive => true;

  List<SnaxNotification> notifications = [];
  Box followingBox;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //Set the notifications to what already exists
    setState(() {
      this.notifications = SnaxNotificationsController.storedNotifications;
    });
    //Refresh on updates
    SnaxNotificationsController.stream.listen((event) {
      setState(() {
        //this.notifications.add(event);
      });
    });
    //Get the following box
    Hive.openBox("user_following").then((box) {
      setState(() {
        this.followingBox = box;
      });
    });
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
              brightness: isDark(context) ? Brightness.dark : Brightness.light,
              centerTitle: true,
              leadingWidth: double.infinity,
              leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 16.0),
                  child: Text("Activity",
                      style: TextStyle(
                        color: getTheme(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ))),
              actions: [],
            ),
          ],
          body: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(indent: 16, height: 0),
              itemBuilder: (BuildContext context, int index) {
                var notif = notifications.reversed.toList()[index];
                switch (notif.type) {
                  case SnaxNotificationType.post:
                    return postActivity(
                        context,
                        notif.title,
                        notif.body,
                        notif.value.split(",")[0],
                        notif.value.split(",")[1],
                        notif.time,
                        getRandomString(9));
                  case SnaxNotificationType.user:
                    return userActivity(context, notif.title, notif.body,
                        notif.value, notif.time, getRandomString(9));
                  default:
                    return defaultActivity(
                        context, notif.title, notif.body, notif.time);
                }
              },
              itemCount: notifications.length),
        ));
  }

  Widget postActivity(BuildContext context, String title, String body,
      String userId, String postId, DateTime time, String transitionId) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FuturePostDetailsPage(postId, transitionId: transitionId),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                          builder: (context) => FutureGlobalAccountPage(
                              userId,
                              (this.followingBox != null &&
                                  this.followingBox.values.contains(userId)),
                              transitionId: transitionId+"u"),
                        ),
                      );
                    },
                    child: Hero(
                      tag: transitionId+"u",
                      child: CircleAvatar(
                          child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                  placeholder: "assets/blank_user.png",
                                  image: userImageURL(userId)))),
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    if (title != null)
                      TextSpan(
                          text: title+'\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark(context)
                                  ? Colors.white
                                  : Colors.black),
                          recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                        text: body,
                        style: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: " " + dateFormatComment(time),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11.5,
                            color: SnaxColors.subtext))
                  ])),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Hero(
                      tag: transitionId,
                                          child: Image.asset(
                        isDark(context) ? "assets/feedPostIconDark.png" : "assets/feedPostIcon.png",
                        height: 40,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget userActivity(BuildContext context, String title, String body,
      String uid, DateTime time, String transitionId) {
    bool isFollowing =
        (this.followingBox != null && this.followingBox.values.contains(uid));
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FutureGlobalAccountPage(uid, isFollowing,
                transitionId: transitionId),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text(comment.user.name),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Hero(
                    tag: transitionId,
                    child: CircleAvatar(
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                                placeholder: "assets/blank_user.png",
                                image: userImageURL(uid)))),
                  ),
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    if (title != null)
                      TextSpan(
                          text: title,
                          style: TextStyle(
                              height: 2,
                              fontWeight: FontWeight.w700,
                              color: isDark(context)
                                  ? Colors.white
                                  : Colors.black),
                          recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                        text: body,
                        style: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: " " + dateFormatComment(time),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11.5,
                            color: SnaxColors.subtext))
                  ])),
                ),
                Container(width: 12),
                FlatButton(
                  onPressed: () async {
                    var f = isFollowing;
                    // setState(() {
                    //   isFollowing = !f;
                    // });
                    if (f) {
                      await SnaxBackend.unfollowUser(uid);
                    } else {
                      await SnaxBackend.followUser(uid);
                    }
                    setState(() {});
                  },
                  height: 30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isFollowing
                          ? getTheme(context).accentColor
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    isFollowing ? "Unfollow" : "Follow",
                    style: TextStyle(
                        color: isFollowing
                            ? getTheme(context).accentColor
                            : getTheme(context).accentContrastForText()),
                  ),
                  color: isFollowing
                      ? Colors.transparent
                      : getTheme(context).accentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultActivity(
      BuildContext context, String title, String body, DateTime time) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Text(comment.user.name),
          Row(
            children: [
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  if (title != null)
                    TextSpan(
                        text: title,
                        style: TextStyle(
                            height: 2,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                  TextSpan(
                      text: body,
                      style: TextStyle(
                          color: isDark(context) ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal)),
                  TextSpan(
                      text: " " + dateFormatComment(time),
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
}

// Widget commentActivity(BuildContext context, String body, String uid) {
//   return Padding(
//     padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         //Text(comment.user.name),
//         Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: CircleAvatar(
//                     backgroundImage: AssetImage("assets/blank_user.png")),
//               ),
//             ),
//             Expanded(
//               child: RichText(
//                   text: TextSpan(children: [
//                 TextSpan(
//                     text: "escher",
//                     style: TextStyle(
//                         height: 2,
//                         fontWeight: FontWeight.w700,
//                         color: isDark(context) ? Colors.white : Colors.black),
//                     recognizer: TapGestureRecognizer()..onTap = () {}),
//                 TextSpan(
//                     text: " liked your comment",
//                     style: TextStyle(
//                         color: isDark(context) ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.normal)),
//                 TextSpan(
//                     text: " " + "2d",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 11.5,
//                         color: SnaxColors.subtext))
//               ])),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget commentOnPost(BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         //Text(comment.user.name),
//         Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: CircleAvatar(
//                     backgroundImage: AssetImage("assets/blank_user.png")),
//               ),
//             ),
//             Expanded(
//               child: RichText(
//                   text: TextSpan(children: [
//                 TextSpan(
//                     text: "escher",
//                     style: TextStyle(
//                         height: 2,
//                         fontWeight: FontWeight.w700,
//                         color: isDark(context) ? Colors.white : Colors.black),
//                     recognizer: TapGestureRecognizer()..onTap = () {}),
//                 TextSpan(
//                     text:
//                         " commented on your post: haha this is so funny and so relatable. You are so cool.",
//                     style: TextStyle(
//                         color: isDark(context) ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.normal)),
//                 TextSpan(
//                     text: " " + "2d",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 11.5,
//                         color: SnaxColors.subtext))
//               ])),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget mention(BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         //Text(comment.user.name),
//         Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: CircleAvatar(
//                     backgroundImage: AssetImage("assets/blank_user.png")),
//               ),
//             ),
//             Expanded(
//               child: RichText(
//                   text: TextSpan(children: [
//                 TextSpan(
//                     text: "escher",
//                     style: TextStyle(
//                         height: 2,
//                         fontWeight: FontWeight.w700,
//                         color: isDark(context) ? Colors.white : Colors.black),
//                     recognizer: TapGestureRecognizer()..onTap = () {}),
//                 TextSpan(
//                     text:
//                         " mentioned you in a comment: @ori literally me. Im actually dying",
//                     style: TextStyle(
//                         color: isDark(context) ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.normal)),
//                 TextSpan(
//                     text: " " + "2d",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 11.5,
//                         color: SnaxColors.subtext))
//               ])),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
