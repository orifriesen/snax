import 'package:flutter/material.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/post.dart';
import 'package:snax/feedPage/feedPage.dart';

import 'package:snax/backend/backend.dart';
import 'package:sup/sup.dart';

import '../../helpers.dart';

class PostTab extends StatefulWidget {
  SnaxUser user;
  PostTab(this.user);

  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab>
    with AutomaticKeepAliveClientMixin<PostTab> {
  List<Post> posts;

  void getPosts() {
    SnaxBackend.feedGetRecentPostsForUser(this.widget.user.uid)
        .then((newPosts) {
      setState(() {
        this.posts = newPosts;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return posts != null
        ? posts.length > 0
            ? Expanded(
                child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Post post = posts[index];
                  return postWidget(context, post);
                },
              ))
            : Padding(
                padding: EdgeInsets.only(top: 44),
                child: QuickSup.empty(
                  title: "No Posts",
                  subtitle: "@" +
                      this.widget.user.username +
                      " doesn't have a lot to say",
                ))
        : Container(
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(SnaxColors.redAccent),
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
