import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/feedPage/post.dart';
import 'package:like_button/like_button.dart';
import 'package:snax/feedPage/postDetailsPage.dart';
import 'package:snax/helpers.dart';
import 'package:snax/homePage/specificSnack.dart';
import 'package:sup/sup.dart';

import '../themes.dart';

StreamController<void> feedTop = StreamController<void>();
Stream feedTopStream = feedTop.stream.asBroadcastStream();

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin<FeedPage> {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> options = [
    {
      "title": "Friends",
      "value": "friends",
      "func": SnaxBackend.feedGetRecentFriendPosts
    },
    {
      "title": "Trending",
      "value": "trending",
      "func": SnaxBackend.feedGetTrendingPosts
    },
    {"title": "Top", "value": "top", "func": SnaxBackend.feedGetTopPosts}
  ];
  String sortValue = (SnaxBackend.currentUser != null) ? "friends" : "trending";

  ScrollController scrollController;

  List<Post> posts;

  Future<void> getPosts({bool pull = false}) async {
    try {
      //make the posts null to show the loading animation (pull has its own loading animation)
      if (!pull)
        setState(() {
          this.posts = null;
        });
      String currentSortValue = sortValue;
      List<Post> newPosts = await this
          .options
          .where((e) => e['value'] == sortValue)
          .first['func'](forceRefresh: pull);

      if (sortValue == currentSortValue)
        setState(() {
          this.posts = newPosts;
        });
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  Widget sortWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          String value;
          try {
            value = await showModalBottomSheet<String>(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                builder: (BuildContext context) {
                  return sortSettings(options, sortValue);
                });
          } catch (error) {}
          if (value == null) return;
          setState(() {
            sortValue = value;
            print(value);
            print(sortValue);
          });
          this.getPosts();
        },
        splashColor: Colors.transparent,
        child: Row(
          children: [
            Text(
              options.firstWhere((e) => e['value'] == sortValue)['title'],
              style: TextStyle(
                  color: getTheme(context).accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget feedText() {
    return Padding(
        padding: EdgeInsets.fromLTRB(
          20.0,
          16,
          16.0,
          24.0,
        ),
        child: Text(
          "Feed",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36.0),
        ));
  }

  @override
  void initState() {
    super.initState();
    print("initting state again ???");
    scrollController = ScrollController();
    getPosts();

    feedTopStream.listen((_) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: isDark(context)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: (posts == null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        bottom: false,
                        child: Container(),
                      ),
                      sortWidget(),
                      feedText(),
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await this.getPosts(pull: true);
                      return;
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: posts.length + ((posts.length == 0) ? 3 : 2),
                      itemBuilder: (context, index) {
                        Post post;
                        if (index == 0) {
                          return sortWidget();
                        }
                        if (index == 1) {
                          post = null;
                          return feedText();
                        } else if (posts.length == 0) {
                          return Padding(
                              padding: EdgeInsets.only(top: 44),
                              child: Center(
                                child: QuickSup.empty(
                                    image: Icon(
                                      Icons.chat_rounded,
                                      size: 25,
                                    ),
                                    title: "No Posts",
                                    subtitle: "It's awfully quiet..."),
                              ));
                        } else {
                          post = posts[index - 2];
                          return postWidget(context, post, refresh: refresh);
                        }
                      },
                    )

                    //Expanded(child: getFeed(context, posts, refresh)),

                    )
            // Column(
            //   children: [
            // FlatButton(
            //   onPressed: () async {
            //     String value = await showModalBottomSheet<String>(
            //         context: context,
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.only(
            //                 topLeft: Radius.circular(24),
            //                 topRight: Radius.circular(24))),
            //         builder: (BuildContext context) {
            //           return sortSettings(options, dropDownValue);
            //         });
            //     setState(() {
            //       dropDownValue = value;
            //       print(value);
            //       print(dropDownValue);
            //     });
            //     this.getPosts();
            //   },
            //   splashColor: Colors.transparent,
            //   child: Row(
            //     children: [
            //       Text(
            //         options.firstWhere(
            //             (e) => e['value'] == dropDownValue)['title'],
            //         style: TextStyle(
            //             color: getTheme(context).accentColor,
            //             fontSize: 20,
            //             fontWeight: FontWeight.w600),
            //       )
            //     ],
            //   ),
            // ),
            //     getFeed(context, posts, refresh),
            //   ],
            // )
            ));
  }
}

Container sortSettings(List<Map<String, dynamic>> options, String value) {
  return Container(
      padding: EdgeInsets.only(top: 4),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            bool current = (options[index]['value'] == value) ? true : false;
            return sortButton(options[index]['title'], current, context);
          }));
}

FlatButton sortButton(String title, bool current, BuildContext context) {
  return FlatButton(
    onPressed: () {
      Navigator.pop(context, title.toLowerCase());
    },
    child: Row(
      children: [
        Icon(
          current ? Icons.check_circle_rounded : Icons.brightness_1_outlined,
          color: current ? getTheme(context).primaryColor : SnaxColors.subtext,
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
        ),
        Text(title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: current ? FontWeight.normal : FontWeight.w300,
            ))
      ],
    ),
  );
}

Widget getFeed(BuildContext context, List<Post> posts, Function refresh) {
  return ListView.builder(
    itemCount: posts.length + ((posts.length == 0) ? 2 : 1),
    itemBuilder: (context, index) {
      Post post;
      if (index == 0) {
        post = null;
        return Padding(
            padding: EdgeInsets.fromLTRB(
              20.0,
              0,
              16.0,
              24.0,
            ),
            child: Text(
              "Feed",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36.0),
            ));
      } else if (posts.length == 0) {
        return Padding(
            padding: EdgeInsets.only(top: 44),
            child: Center(
              child: QuickSup.empty(
                  image: Icon(
                    Icons.chat_rounded,
                    size: 25,
                  ),
                  title: "No Posts",
                  subtitle: "It's awfully quiet..."),
            ));
      } else {
        post = posts[index - 1];
        return postWidget(context, post, refresh: refresh);
      }
    },
  );
}

Widget postWidget(BuildContext context, Post post,
    {bool opensDetails = true, Function refresh, String transitionId}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
    child: GestureDetector(
      onTap: () {
        if (opensDetails)
          Navigator.of(context)
              .push(PageTransition(
            type: PageTransitionType.fade,
            child: PostDetailsPage(post: post),
          ))
              .whenComplete(() {
            if (refresh != null) refresh();
          });
      },
      child: Hero(
        tag: transitionId ?? post.id,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(color: Color.fromARGB(36, 0, 0, 0), blurRadius: 12)
                ],
                gradient: isDark(context)
                    ? LinearGradient(
                        colors: [
                          HexColor.fromHex("3C3C3C"),
                          HexColor.fromHex("2C2C2C")
                        ],
                        begin: Alignment(0, -0.2),
                        end: Alignment(0, 1.5),
                      )
                    : null,
                color: isDark(context) ? null : Theme.of(context).canvasColor),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.all(2),
                        height: 64,
                        width: 64,
                        child: GestureDetector(
                          onTap: () {
                            //             Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => ProductPage(item: post.snack.)));
                          },
                          child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.network(post.snack.image)),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.snack.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: GestureDetector(
                                child: Text(
                                  "@" + post.user.username,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: getTheme(context).accentColor),
                                ),
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GlobalAccountPage(post.user),
                                    ),
                                  ),
                                },
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      post.title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      post.body,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                            child: LikeButton(
                          isLiked: post.likedByMe ? true : false,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite_rounded,
                              color: isLiked
                                  ? Theme.of(context).accentColor
                                  : Colors.grey[350],
                              size: 26.0,
                            );
                          },
                          onTap: (isLiked) async {
                            post.like(!isLiked).then((_) {});

                            return !isLiked;
                          },
                          likeCount: post.likeCount,
                          likeCountPadding: EdgeInsets.only(left: 8),
                          countPostion: CountPostion.right,
                        )),
                        IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: FittedBox(
                              child: LikeButton(
                                likeBuilder: (bool isLiked) {
                                  return Icon(
                                    Icons.chat_rounded,
                                    color: Colors.grey[350],
                                  );
                                },
                                animationDuration: Duration(milliseconds: 0),
                                likeCount: post.commentCount,
                                likeCountPadding: EdgeInsets.only(left: 8),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7, right: 4),
                            child: Text(
                              dateFormatPost(post.time),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[400]),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget fakePostWidget(BuildContext context, {String transitionId}) {
  Color baseColor =
      isDark(context) ? Colors.grey.shade600 : Colors.grey.shade300;
  Color highlightColor = isDark(context) ? Colors.grey : Colors.grey.shade50;

  return Padding(
    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
    child: Hero(
      tag: transitionId ?? getRandomString(9),
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(36, 0, 0, 0), blurRadius: 12)
              ],
              gradient: isDark(context)
                  ? LinearGradient(
                      colors: [
                        HexColor.fromHex("3C3C3C"),
                        HexColor.fromHex("2C2C2C")
                      ],
                      begin: Alignment(0, -0.2),
                      end: Alignment(0, 1.5),
                    )
                  : null,
              color: isDark(context) ? null : Theme.of(context).canvasColor),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[300]),
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.all(2),
                      height: 64,
                      width: 64,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                              child: Container(
                                  width: 150, height: 18, color: Colors.white),
                              baseColor: baseColor,
                              highlightColor: highlightColor),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Opacity(
                                opacity: 0.5,
                                child: Shimmer.fromColors(
                                    child: Container(
                                        width: 60,
                                        height: 14,
                                        color: Colors.white),
                                    baseColor: getTheme(context).gradientStart,
                                    highlightColor:
                                        getTheme(context).gradientEnd)),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Shimmer.fromColors(
                      child: Container(
                          width: 150, height: 16, color: Colors.white),
                      baseColor: baseColor,
                      highlightColor: highlightColor),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[] +
                          ([0, 0, 0]
                              .map((_) => Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Shimmer.fromColors(
                                        child: Container(
                                            height: 16, color: Colors.white),
                                        baseColor: baseColor,
                                        highlightColor: highlightColor),
                                  ))
                              .toList()) +
                          <Widget>[
                            Shimmer.fromColors(
                                child: Container(
                                    width: 100,
                                    height: 16,
                                    color: Colors.white),
                                baseColor: baseColor,
                                highlightColor: highlightColor)
                          ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FittedBox(
                          child: LikeButton(
                        isLiked: false,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite_rounded,
                            color: isLiked
                                ? Theme.of(context).accentColor
                                : Colors.grey[350],
                            size: 26.0,
                          );
                        },
                        likeCount: null,
                        likeCountPadding: EdgeInsets.only(left: 8),
                        countPostion: CountPostion.right,
                      )),
                      IgnorePointer(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: FittedBox(
                            child: LikeButton(
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.chat_rounded,
                                  color: Colors.grey[350],
                                );
                              },
                              animationDuration: Duration(milliseconds: 0),
                              likeCount: null,
                              likeCountPadding: EdgeInsets.only(left: 8),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7, right: 4),
                        child: Shimmer.fromColors(
                            child: Container(
                                width: 40, height: 14, color: Colors.white),
                            baseColor: baseColor,
                            highlightColor: highlightColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
