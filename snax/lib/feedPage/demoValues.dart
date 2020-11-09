import 'package:snax/backend/requests.dart';
import 'package:snax/homePage/snackList.dart';

import 'post.dart';
import 'package:snax/backend/backend.dart';

class DemoValues {
  static List<SnaxUser> demoUsers = [
    SnaxUser("escherwd", "Escher", "68420", "${SnaxBackend.currentUser.bio}"),
    SnaxUser("JD", "JD", "271943", "${SnaxBackend.currentUser.bio}"),
  ];

  static List<SnackSearchResultItem> items = [];

  static List<Post> demoPosts = [
    Post(
        demoUsers[1],
        items[2],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predator.",
        DateTime.now(),
        0,
        0,
        comments: demoComments),
    Post(
        demoUsers[1],
        items[1],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predat",
        DateTime.now(),
        0,
        0,
        comments: demoComments),
    Post(
        demoUsers[1],
        items[3],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predato",
        DateTime.now(),
        0,
        0,
        comments: demoComments),
    Post(
        demoUsers[1],
        items[0],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predator",
        DateTime.now(),
        0,
        0,
        comments: demoComments)
  ];

  static List<Comment> demoComments = [
    Comment(demoUsers[0], "no <3", DateTime.now(), 69),
    Comment(demoUsers[0], "false", DateTime.now(), 420),
    Comment(demoUsers[0], "i-", DateTime.now(), 134),
    Comment(demoUsers[0], "fyp", DateTime.now(), 34209),
    Comment(demoUsers[0], "ur dumb", DateTime.now(), 78),
    Comment(demoUsers[0], "ur stupid", DateTime.now(), 1209),
    Comment(
        demoUsers[0],
        "ur dumb and stupid and dumb and i hate you because you are so unintelligent and dumb",
        DateTime.now(),
        39),
    Comment(demoUsers[0], "ew", DateTime.now(), 392),
  ];
}
