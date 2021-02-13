import 'dart:ffi';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snax/backend/auth.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math';
// written by escher

FirebaseApp fbApp;
FirebaseAuth fbAuth;
FirebaseFirestore fbStore;
FirebaseStorage fbStorage;
FirebaseFunctions fbCloud;
FirebaseMessaging fbMessaging;

Future<void> initializeFirebase() async {
  print("Initializing Firebase");
  //Initialize services
  fbApp = await Firebase.initializeApp();
  fbAuth = FirebaseAuth.instance;
  fbStore = FirebaseFirestore.instance;
  fbCloud = FirebaseFunctions.instance;
  fbStorage = FirebaseStorage.instance;
  fbMessaging = FirebaseMessaging.instance;
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
      //Try to get permission to send notifications
      var notificationRequest = await fbMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true);
      print(notificationRequest.authorizationStatus);
      // Any time the token refreshes, store this in the database too.
      if (notificationRequest.authorizationStatus ==
          AuthorizationStatus.authorized) {
        var token = await FirebaseMessaging.instance.getToken();
        print("got FCM token");
        print(token);
        //Check if the token is already in firebase
        try {
          await SnaxBackend.auth.uploadFCMToken(token);
          print("Uploaded FCM Token to Firebase");
        } catch (error) {
          print(error);
        }
      }
    }
  });

  //Notifications (foreground)
  fbMessaging.setForegroundNotificationPresentationOptions(
      alert: true, sound: true);
  FirebaseMessaging.onMessage.listen(handleNotification);
  FirebaseMessaging.onBackgroundMessage(handleNotification);

  await Hive.initFlutter();
  //uncomment to show login screen on startup
  //navigatorKey.currentState.pushNamed("/login");
}

Future<void> handleNotification(RemoteMessage message) async {
  print("🤠 got a notification! saving to the hive.");
  var box = await Hive.openBox("notifications");
  await box.add(message.data);
  print(box.values);
  await box.close();
}

//A user
class SnaxUser {
  String username;
  String name;
  String uid;
  String bio;
  String photo;

  int followerCount;
  int followingCount;

  bool userIsFollowing;

  Future<void> follow() async {
    await SnaxBackend.followUser(this.uid);
    this.userIsFollowing = true;
  }

  Future<void> unfollow() async {
    await SnaxBackend.unfollowUser(this.uid);
    this.userIsFollowing = false;
  }

  SnaxUser(this.username, this.name, this.uid, this.bio, this.followerCount,
      this.followingCount,
      {this.photo, this.userIsFollowing = false});

  Future<List<SnackUserRating>> ratings({int limit = 10}) =>
      SnaxBackend.getRecentReviewsForUser(this, limit: limit);
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
  String banner;

  String transitionId;
  SnackItem(this.name, this.id, this.type, this.upc, this.averageRatings,
      this.numberOfRatings, this.numberOfRatingsThisWeek, this.image,
      {this.banner}) {
    this.transitionId = getRandomString(10);
  }

  void resetTransitionId() {
    this.transitionId = getRandomString(10);
  }
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

// class SnackUserRatingSnackInfo {
//     String name;
//   String id;
//   SnackItemType type;
//   int upc;
//   String image;
//   String banner;
// }

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
  //The attached data
  SnackItem snack;
  SnaxUser user;

  SnackUserRating(
      this.user,
      this.snack,
      this.overall,
      this.mouthfeel,
      this.accessibility,
      this.snackability,
      this.saltiness,
      this.sourness,
      this.sweetness,
      this.spicyness);
}

//For generating random strings
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
