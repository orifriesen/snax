import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/auth.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/postDetailsPage.dart';
import 'package:snax/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math';
// written by escher

const List<String> founders = ['2sRbgRT7hqd6iLuvYg2VbCC4YDN2', '92kBXfyxAKdkYcwYIRPo7SrKVKj1', 'KZ2OfBJ5cRhAe7BGkC5GamciP253', 'UwmVvSnchmUmlve27a2jcAhtSdk2', 'KyERS8Rbf3XkOmdOeF4mNtUWtS12'];

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

  await Hive.initFlutter();

  //Notifications (foreground)
  fbMessaging.setForegroundNotificationPresentationOptions(
      alert: true, sound: true);
  FirebaseMessaging.onMessage
      .listen(SnaxNotificationsController.handleNotification);
  FirebaseMessaging.onBackgroundMessage((msg) =>
      SnaxNotificationsController.handleNotification(msg, background: true));
  FirebaseMessaging.onMessageOpenedApp
      .listen(SnaxNotificationsController.openNotification);
  var initialMessage = await fbMessaging.getInitialMessage();
  if (initialMessage != null)
    SnaxNotificationsController.openNotification(initialMessage);
  //Get the notifications from storage
  await SnaxNotificationsController.loadNotifications();

  //uncomment to show login screen on startup
  //navigatorKey.currentState.pushNamed("/login");
}

enum SnaxNotificationType {
  post,
  user,
}

class SnaxNotification {
  String title;
  String body;
  SnaxNotificationType type;
  String value;
  DateTime time;

  SnaxNotification(Map<String, dynamic> fromStorage) {
    this.title = fromStorage['notification']['title'];
    this.body = fromStorage['notification']['body'];
    this.value = fromStorage['data']['val'];
    this.time = DateTime.fromMillisecondsSinceEpoch(fromStorage['timestamp']);
    this.type = () {
      switch (fromStorage['data']['type']) {
        case "post":
          return SnaxNotificationType.post;
        case "user":
          return SnaxNotificationType.user;
        default:
          return null;
      }
    }();
  }
}

class SnaxNotificationsController {
  static List<SnaxNotification> storedNotifications = [];
  static StreamController<SnaxNotification> _notificationStream =
      StreamController<SnaxNotification>();
  static Stream stream = _notificationStream.stream.asBroadcastStream();

  static Future<void> handleNotification(RemoteMessage message,
      {bool background = false}) async {
    //Some notifications don't need to be shown in the app. Those ones won't have any data.
    if (message.data == null) return;
    print("🤠 got a notification! saving to the hive.");
    var box = await Hive.openBox("notifications");
    //await box.clear();
    Map<String, dynamic> obj = {
      'data': message.data,
      'notification': {
        'title': message.notification.title,
        'body': message.notification.body
      },
      'timestamp': int.tryParse(message.data['timestamp']) ??
          DateTime.now().millisecondsSinceEpoch
    };
    //Add to storage
    await box.add(jsonEncode(obj));
    //Add to stream
    //if (!background) 
    _notificationStream.add(SnaxNotification(obj));
    //await box.close();
    //Delete from server
    await SnaxNotificationsController.deleteMissedFromServer();
  }

  static void openNotification(RemoteMessage message) {
    if (message.data == null) return;
    var notification = SnaxNotification({
      'data': message.data,
      'notification': {
        'title': message.notification.title,
        'body': message.notification.body
      },
      'timestamp': int.tryParse(message.data['timestamp']) ??
          DateTime.now().millisecondsSinceEpoch
    });
    print("MESSAGE DATA");
    if (notification.type == SnaxNotificationType.post) {
      print("SHOWING POST");
      String id = notification.value.split(",")[1];
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => FuturePostDetailsPage(id: id)));
    } else if (notification.type == SnaxNotificationType.user) {
      print("SHOWING USER");
      String id = notification.value;
      Hive.openBox("user_following").then((followingBox) {
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) =>
                FutureGlobalAccountPage(id, followingBox.values.contains(id))));
      });
    }
  }

  static Future<void> loadNotifications() async {
    //Create the listener for notifications
    stream.listen((n) {
      storedNotifications.add(n);
    });
    //Add the exisiting ones
    var box = await Hive.openBox("notifications");
    //await box.clear();
    List<String> values = box.values.map((e) => e.toString()).toList();
    List<SnaxNotification> notifications =
        values.map((e) => SnaxNotification(jsonDecode(e))).toList();
    print(notifications);
    notifications.forEach((n) {
      _notificationStream.add(n);
    });
    //Get missed notifications
    await SnaxNotificationsController.getMissedNotifications();
  }

  static Future<void> getMissedNotifications() async {
    //Wait for firebase to be initiated
    await waitWhile(() => (fbStore == null));
    await waitWhile(() => (fbAuth == null));
    print("GOING TO GET NOTIFICATIONS");
    //Has to be signed in
    if (fbAuth.currentUser == null) return;
    //Get all the notifications
    var box = await Hive.openBox("notifications");
    QuerySnapshot results = await fbStore
        .collection("activity")
        .where("uid", isEqualTo: fbAuth.currentUser.uid)
        .orderBy("data.timestamp", descending: false)
        .limit(50)
        .get();
    //Parse
    if (results.size == 0) return;
    List<Map<String, dynamic>> objs = results.docs
        .map((e) => ({
              'data': e.data()['data'],
              'notification': e.data()['notification'],
              'timestamp':
                  int.tryParse(e.data()['data']['timestamp']) ?? DateTime.now()
            }))
        .toList();
    box.addAll(objs.map((o) => jsonEncode(o)).toList());
    List<SnaxNotification> notifications =
        objs.map((e) => SnaxNotification(e)).toList();
    //Add to stream
    notifications.forEach((n) {
      _notificationStream.add(n);
    });
    //Delete from server
    await SnaxNotificationsController.deleteMissedFromServer();
  }

  static Future<void> deleteMissedFromServer() async {
    //Wait for fbAuth
    await waitWhile(() => (fbAuth == null));
    //User has to be logged in
    String token = await fbAuth.currentUser.getIdToken();
    //Call
    HttpsCallableResult result =
        await fbCloud.httpsCallable("recievedActivity").call({"token": token});
    //Parse
    if (result.data["status"] == "success") {
      print("Deleted activity from server");
    } else if (result.data["error"] != null) {
      print(result.data["error"]);
    } else {
      print("Failed to delete activity");
    }
  }
}

//A user
class SnaxUser {
  String username;
  String name;
  String uid;
  String bio;
  String photo;
  bool verified;

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
      this.followingCount, this.verified,
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

  Future<bool> hasReviewed() async => SnaxBackend.hasReviewedSnack(this.id);
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
