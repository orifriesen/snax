import 'package:flutter/material.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/feedPage/post.dart';
import 'package:like_button/like_button.dart';
import 'package:snax/feedPage/postDetailsPage.dart';
import 'package:snax/helpers.dart';
import 'package:sup/sup.dart';
import 'package:morpheus/morpheus.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with AutomaticKeepAliveClientMixin<FeedPage> {

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
  String dropDownValue = "friends";

  List<Post> posts;

  void getPosts() async {
    //make the posts null to show the loading animation
    setState(() {
      this.posts = null;
    });

    List<Post> newPosts = await this
        .options
        .where((e) => e['value'] == dropDownValue)
        .first['func']();

    setState(() {
      this.posts = newPosts;
    });
  }

  @override
  void initState() {
    super.initState();
    print("initting state again ???");
    getPosts();
  }

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
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: dropDownValue,
                            icon: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Color.fromARGB(255, 255, 75, 43),
                            ),
                            iconSize: 0,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 75, 43),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                            selectedItemBuilder: (BuildContext context) {
                              return options.map((Map value) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: Text(value['title'],
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 75, 43),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0)),
                                );
                              }).toList();
                            },
                            onChanged: (dynamic newValue) {
                              setState(() {
                                dropDownValue = newValue;
                              });
                              this.getPosts();
                            },
                            items: this
                                .options
                                .map((e) => DropdownMenuItem(
                                    child: Text(e['title']), value: e['value']))
                                .toList()),
                      ),
                    ),
                    actions: [
                      IconButton(
                        padding: EdgeInsets.only(right: 4),
                        icon: Icon(Icons.add_rounded),
                        color: Color.fromARGB(255, 255, 75, 43),
                        iconSize: 28,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MakePostPage(),
                              fullscreenDialog: true));
                        },
                      )
                    ],
                  ),
                ],
            body: (posts == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : getFeed(context, posts, refresh)));
  }
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
        return Padding(padding: EdgeInsets.only(top: 44),child: Center(
                                      child: QuickSup.empty(
                                          image: Icon(Icons.chat_rounded,size: 25,),
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
    {bool opensDetails = true, Function refresh}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
    child: GestureDetector(
      onTap: () {
        if (opensDetails)
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => PostDetailsPage(post: post),
          ))
              .whenComplete(() {
            if (refresh != null) refresh();
          });
      },
      child: Hero(
        tag: post.id,
              child: Material(
                color: Colors.transparent,
                              child: Container(
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
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(post.snack.image)),
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
                                      color: Color.fromARGB(255, 255, 75, 43)),
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
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      post.body,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[400]),
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
