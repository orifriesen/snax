import 'package:snax/homePage/snackList.dart';

import 'post.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/homePage/snackList.dart';

class DemoValues {
  static List<SnaxUser> demoUsers = [
    SnaxUser("escherwd", "Escher", "68420"),
    SnaxUser("JD", "JD", "271943")
  ];

  static List<SnackItem> items = [];

  static List<Post> demoPosts = [
    Post(
        demoUsers[1],
        items[2],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predator.",
        DateTime.now()),
    Post(
        demoUsers[1],
        items[1],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predat",
        DateTime.now()),
    Post(
        demoUsers[1],
        items[3],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predato",
        DateTime.now()),
    Post(
        demoUsers[1],
        items[0],
        "Cheetos gud",
        "Omg i luv cheetos but can we do something about that mascot? He looks like a slimy middle aged man who would be a little league baseball coach predator",
        DateTime.now())
  ];
}
