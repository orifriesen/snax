import 'dart:ffi';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:snax/backend/auth.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

// written by escher

FirebaseApp fbApp;
FirebaseAuth fbAuth;
FirebaseFirestore fbStore;
FirebaseStorage fbStorage;
CloudFunctions fbCloud;

Future<void> initializeFirebase() async {
  print("Initializing Firebase");
  //Initialize services
  fbApp = await Firebase.initializeApp();
  fbAuth = FirebaseAuth.instance;
  fbStore = FirebaseFirestore.instance;
  fbCloud = CloudFunctions.instance;
  fbStorage = FirebaseStorage.instance;
  //Add listeners
  fbAuth.authStateChanges().listen((User user) async {
    if (user == null) {
      print('User is currently signed out!');
      //Reset the current user
      SnaxBackend.currentUser = null;
      //Delete the local data
      SnaxBackend.auth.deleteUserInfoLocally();
    } else {
      print('User is signed in!');
      //Grab the user's data from the server
      SnaxBackend.currentUser = await SnaxBackend.auth.getUserInfo(user);
      print("got current user," + SnaxBackend.currentUser.username);
    }
  });

  //uncomment to show login screen on startup
  //navigatorKey.currentState.pushNamed("/login");
}

//A user
class SnaxUser {
  String username;
  String name;
  String uid;
  String bio;

  SnaxUser(this.username, this.name, this.uid, this.bio);
}

class SnackSearchResultItem {
  String name;
  String id;
  int numberOfRatings;
  double averageRatingOverall;
  String image;

  SnackSearchResultItem(this.name, this.id, this.numberOfRatings,
      this.averageRatingOverall, this.image);

  static fromSnackItem(SnackItem snackItem) => SnackSearchResultItem(
      snackItem.name,
      snackItem.id,
      snackItem.numberOfRatings,
      snackItem.averageRatings.overall,
      snackItem.image);
}

//A type of snack
class SnackItemType {
  String name;
  String id;

  SnackItemType(this.name, this.id);
}

//A Snack
class SnackItem {
  String name;
  String id;
  SnackItemType type;
  int upc;
  SnackRating averageRatings;
  int numberOfRatings;
  int numberOfRatingsThisWeek;
  String image;
  SnackItem(this.name, this.id, this.type, this.upc, this.averageRatings,
      this.numberOfRatings, this.numberOfRatingsThisWeek, this.image);
}

//A snack rating that is calculated, no user data is attached
class SnackRating {
  double overall;
  double mouthfeel;
  double accessibility;
  double snackability;
  double saltiness;
  double sourness;
  double sweetness;
  double spicyness;

  SnackRating(
      this.overall,
      this.mouthfeel,
      this.accessibility,
      this.snackability,
      this.saltiness,
      this.sourness,
      this.sweetness,
      this.spicyness);
}

//A snack rating that a user submitted, user data is attached
class SnackUserRating {
  double overall;
  double mouthfeel;
  double accessibility;
  double snackability;
  double saltiness;
  double sourness;
  double sweetness;
  double spicyness;
  //TODO: add user item

  SnackUserRating(
      this.overall,
      this.mouthfeel,
      this.accessibility,
      this.snackability,
      this.saltiness,
      this.sourness,
      this.sweetness,
      this.spicyness);
}
