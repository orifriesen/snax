import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/main.dart';

import 'backend.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:snax/loginPage/loginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:camerakit/camerakit.dart';
import 'package:camerakit/CameraKitController.dart';
import 'package:camerakit/CameraKitView.dart';

//Cache the snack types, references aren't fetched in these requests so this map will be used.
//Example of what it looks like: { "candy-bar": "Candy Bar", "snack-mix": "Snack Mix" }
Map _snackTypes = {};

class SnaxBackend {
  static SnaxUser currentUser;

  // Top rated snacks of all time
  static Future<List<SnackItem>> chartTop({int limit = 25}) {
    return SnaxBackend._queryAllSnacks("computed.score_overall", true, limit);
  }

  // Snacks with most reviews in the last week
  static Future<List<SnackItem>> chartTrending({int limit = 25}) {
    return SnaxBackend._queryAllSnacks("computed_trend", true, limit);
  }

  static Future<SnackItem> getSnack(String id) async {
    //Wait for the firebase to be initiated
    await _waitWhile(() => (fbStore == null));
    //Make request
    DocumentSnapshot doc = await fbStore.collection("snacks").doc(id).get();
    //Fetch the snack types (if they don't already exist)
    if (_snackTypes.keys.length == 0) {
      (await fbStore.collection("snack-types").get()).docs.forEach((d) {
        _snackTypes[d.id] = d.get("name");
      });
    }
    //Get the image
    String imgUrl;
    try {
      imgUrl = await fbStorage
          .ref()
          .child("snacks")
          .child(doc.id + ".jpg")
          .getDownloadURL();
    } catch (error) {
      // fetch image error
    }
    //Grab the id of the snack type
    String snackTypeId = (doc.get("type") as DocumentReference).id;
    //Return the snack
    return SnackItem(
        doc.get("name"),
        doc.id,
        SnackItemType(_snackTypes[snackTypeId], snackTypeId),
        doc.get("upc"),
        SnackRating(
          toDouble(doc.get("computed.score_overall")),
          toDouble(doc.get("computed.score_mouthfeel")),
          toDouble(doc.get("computed.score_accessibility")),
          toDouble(doc.get("computed.score_snackability")),
          toDouble(doc.get("computed.score_saltiness")),
          toDouble(doc.get("computed.score_sourness")),
          toDouble(doc.get("computed.score_sweetness")),
          toDouble(doc.get("computed.score_spicyness")),
        ),
        doc.get("computed_ratings"),
        doc.get("computed_trend"),
        imgUrl);
  }

  // Private function for getting list of snacks with a sort and limit
  static Future<List<SnackItem>> _queryAllSnacks(
      String sort, bool desc, int limit) async {
    //Wait for the firebase to be initiated
    await _waitWhile(() => (fbStore == null));
    //Get the results, ordered by overall score, with an optional limit.
    List<QueryDocumentSnapshot> results = (await fbStore
            .collection("snacks")
            .orderBy(sort, descending: desc)
            .limit(limit)
            .get())
        .docs;
    //Fetch the snack types (if they don't already exist)
    if (_snackTypes.keys.length == 0) {
      (await fbStore.collection("snack-types").get()).docs.forEach((d) {
        _snackTypes[d.id] = d.get("name");
      });
    }

    //Create the list to return
    List<SnackItem> snacks = [];

    //Iterate through results
    for (var doc in results) {
      //Grab the id of the snack type
      String snackTypeId = (doc.get("type") as DocumentReference).id;
      //Get the image
      String imgUrl;
      try {
        imgUrl = await fbStorage
            .ref()
            .child("snacks")
            .child(doc.id + ".jpg")
            .getDownloadURL();
      } catch (error) {
        // fetch image error
      }
      //Return the snack
      snacks.add(SnackItem(
          doc.get("name"),
          doc.id,
          SnackItemType(_snackTypes[snackTypeId], snackTypeId),
          doc.get("upc"),
          SnackRating(
            toDouble(doc.get("computed.score_overall")),
            toDouble(doc.get("computed.score_mouthfeel")),
            toDouble(doc.get("computed.score_accessibility")),
            toDouble(doc.get("computed.score_snackability")),
            toDouble(doc.get("computed.score_saltiness")),
            toDouble(doc.get("computed.score_sourness")),
            toDouble(doc.get("computed.score_sweetness")),
            toDouble(doc.get("computed.score_spicyness")),
          ),
          doc.get("computed_ratings"),
          doc.get("computed_trend"),
          imgUrl));
    }

    //Return the mapped data
    return snacks;
  }

  static Future<SnackItem> upcResult(int upc) async {
    //Wait for the firebase to be initiated
    await _waitWhile(() => (fbStore == null));
    //Make request
    QuerySnapshot docs = await fbStore.collection("snacks").where("upc", isEqualTo: upc).limit(1).get();
    //If primary upc wasn't a success use a user-generated one
    if (docs.size == 0) docs = await fbStore.collection("snacks").where("upc_extra",arrayContains: upc).limit(1).get();
    //Check size
    if (docs.size == 0) {
      print("found no results for a upc");
      throw "No Results";
    }
    QueryDocumentSnapshot doc = docs.docs[0];
    //Fetch the snack types (if they don't already exist)
    if (_snackTypes.keys.length == 0) {
      (await fbStore.collection("snack-types").get()).docs.forEach((d) {
        _snackTypes[d.id] = d.get("name");
      });
    }
    //Get the image
    String imgUrl;
    try {
      imgUrl = await fbStorage
          .ref()
          .child("snacks")
          .child(doc.id + ".jpg")
          .getDownloadURL();
    } catch (error) {
      // fetch image error
    }
    //Grab the id of the snack type
    String snackTypeId = (doc.get("type") as DocumentReference).id;
    //Return the snack
    return SnackItem(
        doc.get("name"),
        doc.id,
        SnackItemType(_snackTypes[snackTypeId], snackTypeId),
        doc.get("upc"),
        (doc.data()["computed"] != null) ? SnackRating(
          toDouble(doc.data()["computed"]["score_overall"]),
          toDouble(doc.data()["computed"]["score_mouthfeel"]),
          toDouble(doc.data()["computed"]["score_accessibility"]),
          toDouble(doc.data()["computed"]["score_snackability"]),
          toDouble(doc.data()["computed"]["score_saltiness"]),
          toDouble(doc.data()["computed"]["score_sourness"]),
          toDouble(doc.data()["computed"]["score_sweetness"]),
          toDouble(doc.data()["computed"]["score_spicyness"]),
        ) : SnackRating(null,null,null,null,null,null,null,null),
        doc.data()["computed_ratings"],
        doc.data()["computed_trend"],
        imgUrl);
  }

  static Future<List<SnackSearchResultItem>> search(String query) async {
    //Wait for the cloud functions client to be initiated
    await _waitWhile(() => (fbCloud == null));
    //Call search function from database
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "searchSnacks")
        .call({"q": query.trim()});
    //Parse
    if (result.data["status"] == "success") {
      //Create the results list and an empty classed list
      List resultItems = result.data["results"];
      List<SnackSearchResultItem> returnItems = [];
      //Iterate through search results
      for (var result in resultItems) {
        //Get the image url
        String imgUrl;
        try {
          imgUrl = await fbStorage
              .ref()
              .child("snacks")
              .child(result["id"].toString() + ".jpg")
              .getDownloadURL();
        } catch (error) {}

        //Add to the list
        returnItems.add(SnackSearchResultItem(
            result["name"].toString(),
            result["id"].toString(),
            (result["count"] != null) ? (result["count"]) as int : null,
            (result["overall"] != null) ? (result["overall"]).toDouble() : null,
            imgUrl));
      }
      //Return the list
      return returnItems;
    } else if (result.data["error"] != null) {
      throw result.data["error"];
    } else {
      throw "An unknown error occurred, please try again later";
    }
  }

  static Future<void> postReview(String snackId, SnackRating rating) async {
    //Wait for fbAuth
    await _waitWhile(() => (fbAuth == null));
    //User has to be logged in
    await auth.loginIfNotAlready();
    String token = await fbAuth.currentUser.getIdToken();
    //Create the request body
    Object body = {
      "snack_id": snackId,
      "token": token,
      "ratings": {
        "overall": rating.overall,
        "mouthfeel": rating.mouthfeel,
        "accessibility": rating.accessibility,
        "snackability": rating.snackability,
        "saltiness": rating.saltiness,
        "sourness": rating.sourness,
        "sweetness": rating.sweetness,
        "spicyness": rating.spicyness
      }
    };
    //Call
    HttpsCallableResult result =
        await fbCloud.getHttpsCallable(functionName: "rateSnack").call(body);
    //Parse
    if (result.data["status"] == "success") {
      //TODO: Remove toast
      Fluttertoast.showToast(msg: "Ratings Sent!");
      return;
    } else if (result.data["error"] != null) {
      throw result.data["error"];
    } else {
      throw "An unknown error occurred, please try again later";
    }
  }

  static _SnaxBackendAuth auth = _SnaxBackendAuth();
}

class _SnaxBackendAuth {
  //Auth stuff
  Future<SnaxUser> loginIfNotAlready() async {
    bool loggedIn;

    if (fbAuth.currentUser != null) {
      return SnaxBackend.currentUser;
    } else {
      navigatorKey.currentState.pushNamed("/login",
          arguments: LoginPageArguments((bool success) {
        loggedIn = success;
      }));
    }

    //Wait for the login
    await _waitWhile(() => (loggedIn == null));

    //If the user didnt log in
    if (!loggedIn) throw "You must log in first.";

    print("User Logged in via loginIfNotAlready");

    //Wait for the current user to be fetched from the database and return
    await _waitWhile(() => (SnaxBackend.currentUser == null));
    return SnaxBackend.currentUser;
  }

  Future<SnaxUser> getUserInfo(User user, {int attempt = 0}) async {
    //The user's instance takes a second to be created when the account is made, so it has 4 chances to fetch it before throwing.
    if (attempt >= 4)
      throw "User not found. Please try logging in again later.";

    DocumentSnapshot userInDB;
    try {
      userInDB = await fbStore.collection("users").doc(user.uid).get();
    } catch (error) {
      //Try to get it locally
      return getUserInfoLocally();
    }

    if (!userInDB.exists) {
      //Wait two seconds and check again
      await Future.delayed(Duration(seconds: 2));
      return await getUserInfo(user, attempt: attempt + 1);
    } else {
      //Update the local data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", user.uid);
      await prefs.setString("user_username", userInDB.get("username"));
      await prefs.setString("user_name", userInDB.get("name"));
      //Return instance
      return SnaxUser(userInDB.get("username"), userInDB.get("name"), user.uid);
    }
  }

  Future<SnaxUser> getUserInfoLocally() async {
    print("[SnaxBackend] Resorting to local user data, server fetch failed");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user_id")) {
      return SnaxUser(prefs.getString("user_username"),
          prefs.getString("user_name"), prefs.getString("user_id"));
    } else {
      throw "No user data present";
    }
  }

  Future<void> deleteUserInfoLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");
    await prefs.remove("user_username");
    await prefs.remove("user_name");
  }
}

// Extra Utility Functions

double toDouble(dynamic number) {
  if (number is String) {
    return double.parse(number);
  } else if (number is int) {
    return 0.0 + number;
  } else {
    return number;
  }
}

Future _waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
  var completer = new Completer();
  check() {
    if (!test()) {
      completer.complete();
    } else {
      new Timer(pollInterval, check);
    }
  }

  check();
  return completer.future;
}
