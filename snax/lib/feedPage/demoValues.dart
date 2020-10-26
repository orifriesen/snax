import 'package:snax/homePage/snackList.dart';

import 'post.dart';
import 'package:snax/backend/backend.dart';

class DemoValues {
  static List<SnaxUser> demoUsers = [
    SnaxUser("escherwd", "Escher", "68420"),
    SnaxUser("JD", "JD", "271943")
  ];

  static List<SnackSearchResultItem> items = [];

  static List<Post> demoPosts = [
    Post(
        demoUsers[1],
        items[2],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predator.",
        DateTime.now(),
        demoComments),
    Post(
        demoUsers[1],
        items[1],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predat",
        DateTime.now(),
        demoComments),
    Post(
        demoUsers[1],
        items[3],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predato",
        DateTime.now(),
        demoComments),
    Post(
        demoUsers[1],
        items[0],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predator",
        DateTime.now(),
        demoComments)
  ];

  static List<Comment> demoComments = [
    Comment(demoUsers[0], "no <3", DateTime.now()),
    Comment(demoUsers[0], "false", DateTime.now()),
    Comment(demoUsers[0], "i-", DateTime.now()),
    Comment(demoUsers[0], "fyp", DateTime.now()),
    Comment(demoUsers[0], "ur dumb", DateTime.now()),
    Comment(demoUsers[0], "ur stupid", DateTime.now()),
    Comment(
        demoUsers[0],
        "ur dumb and stupid and dumb and i hate you because you are so unintelligent and dumb",
        DateTime.now()),
    Comment(demoUsers[0], "ew", DateTime.now()),
  ];
}
