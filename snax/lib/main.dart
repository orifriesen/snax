import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snax/feedPage/demoValues.dart';
import 'package:snax/feedPage/postDetailsPage.dart';
import 'package:snax/loginPage/loginPage.dart';
import 'package:snax/tabs.dart';
import 'package:snax/themes.dart';
import 'backend/backend.dart';
import 'backend/requests.dart';
import 'package:snax/helpers.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

//Navigator key allows for background tasks to present views without context (used for Firebase listeners)
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

BuildContext globalContext;
StreamController<void> themeUpdate = StreamController<void>();
Stream themeUpdateStream = themeUpdate.stream;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    themeUpdateStream.listen((_) {
      setState(() {});
    });

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey("dark-theme"))
        currentDarkTheme = darkThemeList
            .firstWhere((t) => t.id == prefs.getString("dark-theme"));
      if (prefs.containsKey("light-theme"))
        currentLightTheme = lightThemeList
            .firstWhere((t) => t.id == prefs.getString("light-theme"));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        print("tapped");
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        key: Key("app"),
        navigatorKey: navigatorKey,
        routes: {
          //Route the app will stay in most of the time
          "/": (context) => AppTabs(),
          //Top-level route to present login screen w/ navigatorKey
          "/login": (context) => LoginPage(),
          //A feed post
          "/post": (context) => FuturePostDetailsPage(),
        },
        initialRoute: "/",
        darkTheme: ThemeData(
            canvasColor: HexColor.fromHex("252525"),
            primaryColor: currentDarkTheme.primaryColor,
            accentColor: currentDarkTheme.accentColor,
            brightness: ThemeData.dark().brightness,
            appBarTheme: AppBarTheme(color: currentDarkTheme.appBarColor),
            cupertinoOverrideTheme: CupertinoThemeData(
                primaryColor: currentDarkTheme.primaryColor)),
        theme: ThemeData(
            primaryColor: currentLightTheme.primaryColor,
            accentColor: currentLightTheme.accentColor,
            cupertinoOverrideTheme:
                CupertinoThemeData(primaryColor: currentDarkTheme.primaryColor),
            appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: currentLightTheme.appBarContrastForText()),
                color: currentLightTheme.appBarColor)),
      ),
    );
  }
}

void main() async {
  runApp(MyApp());

  //Initialize Firebase synchronously (has to happen after runApp)
  initializeFirebase().whenComplete(() {
    print("initialized firebase");
    // SnaxBackend.search("Cheet").then((value) {
    //   DemoValues.items = value;
    // });
    if (fbAuth.currentUser != null)
      fbAuth.currentUser.getIdToken().then((token) => printWrapped(
          "USER REQUEST TOKEN =-=-=-=-=-=-=-=-=-=-=-\n" +
              token +
              "\n=-=-=-=-=-=-=-=-=-=-=-"));

    // SnaxBackend.getFollowing("92kBXfyxAKdkYcwYIRPo7SrKVKj1").then((users) {
    //   users.forEach((u) {
    //     print("${u.name} - ${u.username}");
    //   });
    // });

    // SnaxBackend.updateProfile(username: "escher2",bio: "").then((_) {
    //     print("updated my bio from the app!");
    // });

    //SnaxBackend.getRecentReviewsForUser(SnaxBackend.currentUser).then((_) {});

    // SnaxBackend.followUser("aWBb2fFQL5as5QiUs9leo3DiA1C3").then((_) {});

    // SnaxBackend.feedGetTrendingPosts().then((posts) {
    //   print("posts for trending");
    //   for (var post in posts) {
    //     print(post.body);
    //   }
    // });

    // SnaxBackend.searchUsers("esc").then((r) {
    //   r.first.ratings().then((rs) {
    //     rs.forEach((element) {
    //       print(element.snack.name);
    //       print(element.snack.image);
    //       print(element.overall);
    //     });
    //   });
    // });

    // SnaxBackend.feedLikePost("rlUXJBRe1MfKXI49Ux8M").then((_) {});

    // SnaxUser("doesntmatter", "notimportant", "AF9IkBebqtSAtMprjipQglu6B1D2", null, 0, 0).unfollow().then((_) {
    //   print("followed a user");
    // });

    // SnaxBackend.getSnacksInCategory("chip", SnackListSort.top).then((snacks) {
    //   print("GOT SNACKS FROM CATEGORY!");
    //   snacks.forEach((snack) { print(snack.name); });
    // });
    // SnaxBackend.auth.logOut(restartApp: false).then((_) { print("logged out"); });
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
