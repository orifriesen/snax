import 'package:flutter/material.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/feedPage/post.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:snax/feedPage/postDetailsPage.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<String> options = ["Trending", "New", "Top"];
  String dropDownValue = "Top";

  List<Post> posts;

  void getPosts() {
    SnaxBackend.feedGetTopPosts().then((newPosts) {
      setState(() {
        this.posts = newPosts;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool isScrolled) => [
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    backgroundColor: Colors.white,
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
                              return options.map((String value) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: Text(dropDownValue,
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 75, 43),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0)),
                                );
                              }).toList();
                            },
                            onChanged: (String newValue) async {
                              List<Post> newPosts;
                              if (newValue == "Top") {
                                print("getting top posts");
                                newPosts = await SnaxBackend.feedGetTopPosts();
                              } else
                                newPosts = DemoValues.demoPosts;
                              setState(() {
                                dropDownValue = newValue;
                                posts = newPosts;
                                print(posts.length.toString() + " posts");
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                child: Text("Trending"),
                                value: "Trending",
                              ),
                              DropdownMenuItem(
                                child: Text("New"),
                                value: "New",
                              ),
                              DropdownMenuItem(
                                child: Text("Top"),
                                value: "Top",
                              )
                            ]),
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
                : getFeed(context, posts)));
  }
}

Widget getFeed(BuildContext context, List<Post> posts) {
  return ListView.builder(
    itemCount: posts.length + 1,
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
      } else {
        post = posts[index - 1];
        return postWidget(context, post);
      }
    },
  );
}

Widget postWidget(BuildContext context, Post post) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostDetailsPage(post: post),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: Color.fromARGB(36, 0, 0, 0), blurRadius: 12)
            ],
            color: Colors.white),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
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
                          child: Text(
                            "@" + post.user.username,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 75, 43)),
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
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite_rounded,
                          color: isLiked
                              ? Theme.of(context).accentColor
                              : Colors.grey[350],
                          size: 26.0,
                        );
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
  );
}
