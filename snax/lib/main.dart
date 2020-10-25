import 'package:flutter/material.dart';
import 'package:snax/feedPage/demoValues.dart';
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
    SnaxBackend.chartTop().then((value) {
      DemoValues.items = value;
    });
    // SnaxBackend.postReview("doritos-bbq-rib", SnackRating(4.0,4.0,4.0,5.0,4.0,0.0,0.0,1.0)).then((d) {
    //   print("sent review");
    // });
    // SnaxBackend.chartTop().then((snacks) => {
    //   snacks.forEach((snack) { 
    //     print(snack.id);
    //     print(snack.image);
    //    })
    // });
  });
}
