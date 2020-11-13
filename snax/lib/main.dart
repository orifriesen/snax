import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/loginPage/loginPage.dart';
import 'package:snax/tabs.dart';
import 'backend/backend.dart';
import 'backend/requests.dart';
import 'package:snax/helpers.dart';

//Navigator key allows for background tasks to present views without context (used for Firebase listeners)
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        //Route the app will stay in most of the time
        "/": (context) => AppTabs(),
        //Top-level route to present login screen w/ navigatorKey
        "/login": (context) => LoginPage()
      },
      initialRoute: "/",
      darkTheme: ThemeData(
          canvasColor: HexColor.fromHex("252525"),
          primaryColor: SnaxColors.redAccent,
          accentColor: SnaxColors.redAccent,
          cursorColor: SnaxColors.redAccent,
          brightness: ThemeData.dark().brightness,
          cupertinoOverrideTheme:
              CupertinoThemeData(primaryColor: SnaxColors.redAccent)),
      theme: ThemeData(
          primaryColor: SnaxColors.redAccent,
          accentColor: SnaxColors.redAccent,
          cupertinoOverrideTheme:
              CupertinoThemeData(primaryColor: SnaxColors.redAccent),
          appBarTheme: AppBarTheme(brightness: Brightness.light)),
    );
  }
}

void main() {
  runApp(MyApp());

  //Initialize Firebase synchronously (has to happen after runApp)
  initializeFirebase().whenComplete(() {
    print("initialized firebase");
    SnaxBackend.search("Cheet").then((value) {
      DemoValues.items = value;
    });
    if (fbAuth.currentUser != null) fbAuth.currentUser.getIdToken().then((token) => printWrapped("USER REQUEST TOKEN =-=-=-=-=-=-=-=-=-=-=-\n"+token+"\n=-=-=-=-=-=-=-=-=-=-=-"));
    SnaxBackend.feedGetTopPosts().then((posts) => {
          posts.forEach((post) {
            print(post.title);
            print(post.body);
            print(post.snack.name);
            print(post.user.name);
            print(post.user.username);
            print(post.time);
            print(post.likeCount);
          })
        });
    // SnaxBackend.updateProfile(username: "escher2",bio: "").then((_) {
    //     print("updated my bio from the app!");
    // });
    print(DemoValues.items.length);
    //SnaxBackend.feedLikePost("rlUXJBRe1MfKXI49Ux8M").then((_) {});
    SnaxBackend.feedGetComments("rlUXJBRe1MfKXI49Ux8M").then((comments) {
      for (var comment in comments) {
        print(comment.body);
        print(comment.user.name);
      }
    });
    // SnaxBackend.feedCommentOnPost("rlUXJBRe1MfKXI49Ux8M", "fyp").then((_) {
    //   print("made a comment");
    // });
    // SnaxBackend.postReview("doritos-bbq-rib", SnackRating(4.0,4.0,4.0,5.0,4.0,0.0,0.0,1.0)).then((d) {
    //   print("sent review");
    // });
    // SnaxBackend.search("Pringles").then((search) {
    //   search.forEach((result) {
    //     print(result.id);
    //     print(result.name);
    //     print(result.numberOfRatings);
    //     print(result.averageRatingOverall);
    //     print(result.image);
    //    });
    // });
    // SnaxBackend.getSnack("pringles-pizza").then((snack) {
    //   print(snack.name);
    // });

    // SnaxBackend.feedMakePost("Test Post", "this is a post by escher", "goldfish-cheddar").then((_) {
    //   print("sent");
    // }).catchError((error) {
    //   print("error");
    // });
    // SnaxBackend.upcResult(885191430955).then((snack) {
    //   print(snack.id);
    // }).catchError((err) {
    //   print(err);
    // });
  });
}

