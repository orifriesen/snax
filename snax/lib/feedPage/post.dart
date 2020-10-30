import 'package:snax/backend/backend.dart';
import 'package:snax/homePage/homePage.dart';
import 'package:snax/homePage/snackList.dart';

class Post {
  SnaxUser user;
  SnackSearchResultItem snack;
  String title;
  String body;
  DateTime time;
  int likeCount = 0;
  int commentCount = 0;
  List<Comment> comments = <Comment>[];

  Post(this.user, this.snack, this.title, this.body, this.time, this.likeCount,
      this.commentCount,
      {this.comments});
}

class Comment {
  SnaxUser user;
  String body;
  DateTime time;
  int likes = 0;
  List<Comment> comments = [];

  Comment(this.user, this.body, this.time, this.likes);
}
