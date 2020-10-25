import 'package:snax/backend/backend.dart';
import 'package:snax/homePage/homePage.dart';
import 'package:snax/homePage/snackList.dart';

class Post {
  SnaxUser user;
  SnackItem snack;
  String title;
  String body;
  DateTime time;
  int likes;

  Post(this.user, this.snack, this.title, this.body, this.time);
}
