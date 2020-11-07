import 'package:flutter/material.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/post.dart';
import 'package:snax/feedPage/feedPage.dart';

import '../../helpers.dart';

class PostTab extends StatefulWidget {
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab>
    with AutomaticKeepAliveClientMixin<PostTab> {
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
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return posts != null
        ? Expanded(
            child: ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Post post = posts[index];
              return postWidget(context, post);
            },
          ))
        : Expanded(
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
