import 'package:flutter/material.dart';
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
  String dropDownValue = "Trending";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DropdownButtonHideUnderline(
            child: DropdownButton(
                value: dropDownValue,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.white,
                ),
                iconSize: 32.0,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
                selectedItemBuilder: (BuildContext context) {
                  return options.map((String value) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(dropDownValue,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0)),
                    );
                  }).toList();
                },
                onChanged: (String newValue) {
                  setState(() {
                    dropDownValue = newValue;
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_comment_rounded),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MakePostPage(), fullscreenDialog: true));
          },
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
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostDetailsPage(post: demoPosts[index]),
                  fullscreenDialog: true));
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        visualDensity: VisualDensity.compact,
                        leading: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(
                              demoPosts[index].snack.image,
                              scale: 4,
                            )),
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
        ),
      );
    },
  );
}
