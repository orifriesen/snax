import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/homePage/homePage.dart';
import 'package:snax/homePage/snackList.dart';
import 'package:intl/intl.dart';

class Post {
  String id;
  SnaxUser user;
  SnackSearchResultItem snack;
  String title;
  String body;
  DateTime time;
  int likeCount = 0;
  int commentCount = 0;
  List<Comment> comments = <Comment>[];

  //Shortcuts
  Future<void> like() => SnaxBackend.feedLikePost(id);
  Future<void> comment(String content) => SnaxBackend.feedCommentOnPost(id,content);
  Future<List<Comment>> getComments() => SnaxBackend.feedGetComments(id);

  Post(this.id,this.user, this.snack, this.title, this.body, this.time, this.likeCount,
      this.commentCount,
      {this.comments});
}

class Comment {
  String id;
  String postId;
  SnaxUser user;
  String body;
  DateTime time;
  int likes = 0;
  List<Comment> comments = [];

  //Shortcuts
  Future<void> like() => SnaxBackend.feedLikeComment(postId, id);

  Comment(this.id, this.postId, this.user, this.body, this.time, this.likes);
}

String dateFormatPost(DateTime time) {
  Duration difference = time.difference(DateTime.now());
  difference *= -1;
  if (difference.inMinutes <= 60)
    return difference.inMinutes.toString() +
        ((difference.inMinutes != 1) ? " minutes ago" : " minute ago");
  else if (difference.inHours <= 24)
    return difference.inHours.toString() +
        ((difference.inHours != 1) ? " hours ago" : " hour ago");
  else if (difference.inDays <= 7)
    return difference.inDays.toString() +
        ((difference.inDays != 1) ? " days ago" : " day ago");
  else if (difference.inDays <= 28)
    return (difference.inDays / 7).floor().toString() +
        (((difference.inDays / 7).floor() != 1) ? " weeks ago" : " week ago");
  else if (difference.inDays <= 365)
    return DateFormat("MMM d").format(time);
  else
    return DateFormat("yMd").format(time);
}

String dateFormatComment(DateTime time) {
  Duration difference = time.difference(DateTime.now());
  difference *= -1;
  if (difference.inMinutes <= 60)
    return difference.inMinutes.toString() + "m";
  else if (difference.inHours <= 24)
    return difference.inHours.toString() + "h";
  else if (difference.inDays <= 7)
    return difference.inDays.toString() + "d";
  else if (difference.inDays <= 28)
    return (difference.inDays / 7).floor().toString() + "w";
  else if (difference.inDays <= 365)
    return DateFormat("MMM d").format(time);
  else
    return DateFormat("yMd").format(time);
}
