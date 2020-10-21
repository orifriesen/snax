import 'package:flutter/material.dart';
import 'package:snax/loginPage/loginPage.dart';
import 'package:snax/tabs.dart';
import 'backend/backend.dart';
import 'backend/requests.dart';



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
        theme: ThemeData(
            primaryColor: Colors.red, accentColor: Colors.redAccent[100]),
      );
  }
}

void main() {
  runApp(MyApp());

  //Initialize Firebase synchronously (has to happen after runApp)
  initializeFirebase().whenComplete(() {
    print("initialized firebase");

    // me testing the backend functions

    // SnaxBackend.postReview("lays-limon", SnackRating(2.0,1.0,4.0,4.0,2.0,4.0,0.0,0.0)).then((d) {
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
  });
}
