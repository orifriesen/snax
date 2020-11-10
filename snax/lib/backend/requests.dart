import 'dart:async';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snax/feedPage/post.dart';
import 'package:snax/main.dart';

import 'backend.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:snax/loginPage/loginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image/image.dart';

import 'package:path_provider/path_provider.dart';

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
        (doc.data()["computed"] != null)
            ? SnackRating(
                toDouble(doc.get("computed.score_overall")),
                toDouble(doc.get("computed.score_mouthfeel")),
                toDouble(doc.get("computed.score_accessibility")),
                toDouble(doc.get("computed.score_snackability")),
                toDouble(doc.get("computed.score_saltiness")),
                toDouble(doc.get("computed.score_sourness")),
                toDouble(doc.get("computed.score_sweetness")),
                toDouble(doc.get("computed.score_spicyness")),
              )
            : null,
        doc.data()["computed_ratings"],
        doc.data()["computed_trend"],
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

  

  //This random string is being used as an alternative to 'undefined' which doesnt exist in dart
  static const _undefinedBioString = "zX43XBOZ7PtzulR";

  static Future<void> updateProfile({String username,String name,String bio = _undefinedBioString}) async {
    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    await _waitWhile(() => (currentUser == null));

  if (username == currentUser.username) username = null;
    if (name == currentUser.name) name = null;
    if (bio == currentUser.bio || bio == "") bio = _undefinedBioString;

    Map<String,String> params = {"token":token};
    if (username != null) params["username"] = username;
    if (name != null) params["name"] = name;
    if (bio != _undefinedBioString) params["bio"] = bio;

    

    //Send request
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "updateProfile")
        .call(params);
    
    if (result.data["status"] == "success") {
      return;
    } else {
      throw result.data["error"];
    }
  }

  static Future<void> updateProfilePhoto(PickedFile pickedFile) async {
    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();
    String uid = fbAuth.currentUser.uid;

    //Resize and reformat image
    Image image = decodeImage(await pickedFile.readAsBytes());
    Image resized = copyResize(image, width: 400, height: 400);
    io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    io.File file = io.File(appDocDirectory.path+'$uid.jpg');
    await file.writeAsBytes(encodeJpg(resized));

    try {
      await fbStorage.ref().child("user-profiles").child(uid+".jpg").putFile(file).onComplete;
    } catch (error) {
      print(error);
      throw "Failed to upload";
    }
  }

  static Future<void> feedMakePost(
      String title, String body, String snackId) async {
    //Check all the values
    if (title.isEmpty ||
        title == null ||
        body.isEmpty ||
        body == null ||
        snackId == null) {
      throw "Missing Data";
    } else if (title.length > 100 || body.length > 500) {
      throw "Your title or body is too long";
    }

    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    //Send request
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "feedMakePost")
        .call({
      "snack_id": snackId,
      "title": title,
      "body": body,
      "token": token
    });

    if (result.data["status"] == "success") {
      return;
    } else {
      throw result.data["error"];
    }
  }

  static Future<void> feedLikeComment(String postId, String commentId, bool like) async {
    if (commentId == null || postId == null) {
      throw "Missing Data";
    }

    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    //Send request
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "feedLike")
        .call({"post_id": postId, "comment_id": commentId, "token": token, "unlike": !like});

    if (result.data["status"] != "success") throw result.data["error"];
  }

  static Future<void> feedLikePost(String postId, bool like) async {
    print("like function");

    if (postId == null) {
      throw "Missing Data";
    }

    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    print("fart");
    //Send request
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "feedLike")
        .call({"post_id": postId, "token": token, "unlike": !like});

        print(result.data);

    if (result.data["status"] != "success") throw result.data["error"];
  }

  static Future<List<Post>> feedGetTopPosts() async {
    //Wait for firebase init
    await _waitWhile(() => (fbStore == null));
    List<QueryDocumentSnapshot> docs = (await fbStore
            .collection("feed")
            .orderBy("likes", descending: true)
            .limit(25)
            .get())
        .docs;
    return docs.isNotEmpty ? await _feedGrabRefs(docs) : [];
  }

  static Future<List<Comment>> feedGetComments(String postId) async {
    //Wait for firebase init
    await _waitWhile(() => (fbStore == null));
    List<QueryDocumentSnapshot> docs = (await fbStore
            .collection("feed")
            .doc(postId)
            .collection("comments")
            .get())
        .docs;
    return docs.isNotEmpty ? await _feedGrabRefsComments(docs, postId) : [];
  }

  static Future<Comment> feedCommentOnPost(
      String postId, String content) async {
    if (content.isEmpty || content == null || postId == null) {
      throw "Missing Data";
    } else if (content.length > 500) {
      throw "Your title or body is too long";
    }

    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    //Send request
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "feedMakeComment")
        .call({"post_id": postId, "content": content, "token": token});

    if (result.data["status"] != "success") throw result.data["error"];

    String commentId = result.data["id"];
    int timestamp = result.data["timestamp"];

    return Comment(commentId, postId, SnaxBackend.currentUser, content,
        DateTime.fromMillisecondsSinceEpoch(timestamp), 0);
  }

  //Grabs user info to link with comments
  static Future<List<Comment>> _feedGrabRefsComments(
      List<QueryDocumentSnapshot> docs, String postId) async {
    //Create an empty list and add all the user ids
    List<String> userIds = [];
    docs.forEach((doc) {
      //Add user id
      if (!userIds.contains(doc.data()["uid"])) userIds.add(doc.data()["uid"]);
    });
    //Get all the users
    List<QueryDocumentSnapshot> userDocs = (await fbStore
            .collection("users")
            .where(FieldPath.documentId, whereIn: userIds)
            .get())
        .docs;
    //Organize the data
    Map<String, Map> userDatas = {};
    userDocs.forEach((e) {
      userDatas[e.id] = e.data();
    });
    //Create an empty list to return
    List<Comment> comments = [];
    for (var doc in docs) {
      var data = doc.data();
      SnaxUser user = SnaxUser(
          userDatas[data["uid"]]["username"],
          userDatas[data["uid"]]["name"],
          data["uid"],
          userDatas[data["uid"]]["bio"]);
      comments.add(Comment(
          doc.id,
          postId,
          user,
          data["content"],
          DateTime.fromMillisecondsSinceEpoch(data["timestamp"]),
          data["likes"] ?? 0));
    }
    return comments;
  }

  //Grab extra info like user and snack for a given list of feed database items
  static Future<List<Post>> _feedGrabRefs(
      List<QueryDocumentSnapshot> docs) async {
    //Prepare to grab all the snack and user ids
    List<String> userIds = [];
    List<String> snackIds = [];
    docs.forEach((doc) {
      //Add user id
      if (!userIds.contains(doc.data()["uid"])) userIds.add(doc.data()["uid"]);
      //Add snack id
      if (!snackIds.contains(doc.data()["snack_id"]))
        snackIds.add(doc.data()["snack_id"]);
    });
    //Grab all
    List<QuerySnapshot> results = await Future.wait([
      fbStore
          .collection("snacks")
          .where(FieldPath.documentId, whereIn: snackIds)
          .get(),
      fbStore
          .collection("users")
          .where(FieldPath.documentId, whereIn: userIds)
          .get()
    ]);
    //Organize the data
    Map<String, Map> snackDatas = {};
    results[0].docs.forEach((e) {
      snackDatas[e.id] = e.data();
    });
    Map<String, Map> userDatas = {};
    results[1].docs.forEach((e) {
      userDatas[e.id] = e.data();
    });
    //Create posts
    List<Post> posts = [];
    for (var doc in docs) {
      var data = doc.data();
      if (!snackDatas.containsKey(data["snack_id"]) ||
          !userDatas.containsKey(data["uid"])) continue;
      
      //Get snack image
      String snackImg;
      String userImg;

      try {
        snackImg = await fbStorage
            .ref()
            .child("snacks")
            .child(data["snack_id"] + ".jpg")
            .getDownloadURL();
        userImg = await fbStorage
            .ref()
            .child("user-profiles")
            .child(data["uid"] + ".jpg")
            .getDownloadURL();
      } catch (error) {}

      //Create user
      SnaxUser user = SnaxUser(
          userDatas[data["uid"]]["username"],
          userDatas[data["uid"]]["name"],
          data["uid"],
          userDatas[data["uid"]]["bio"], photo: userImg);

      //Create snack
      SnackSearchResultItem snack = SnackSearchResultItem(
          snackDatas[data["snack_id"]]["name"],
          data["snack_id"],
          snackDatas[data["snack_id"]]["computed_ratings"],
          toDouble((snackDatas[data["snack_id"]]["computed"] ??
              {"score_overall": null})["score_overall"]),
          snackImg);
      //Add post
      posts.add(Post(
          doc.id,
          user,
          snack,
          data["post_title"],
          data["post_body"],
          DateTime.fromMillisecondsSinceEpoch(data["timestamp"]),
          data["likes"],
          data["comments"]));
    }
    return posts;
  }

  static Future<void> addUpc(int upc, String snackId) async {
    //Wait for the cloud functions client to be initiated
    await _waitWhile(() => (fbCloud == null));
    //Call search function from database
    HttpsCallableResult result = await fbCloud
        .getHttpsCallable(functionName: "addUserUpc")
        .call({"upc": upc.toString(), "snack_id": snackId});
    //Parse
    if (result.data["status"] == "success") {
      return;
    } else {
      throw result.data["error"];
    }
  }

  static Future<SnackItem> upcResult(int upc) async {
    //Wait for the firebase to be initiated
    await _waitWhile(() => (fbStore == null));
    //Make request
    QuerySnapshot docs = await fbStore
        .collection("snacks")
        .where("upc", isEqualTo: upc)
        .limit(1)
        .get();
    //If primary upc wasn't a success use a user-generated one
    if (docs.size == 0)
      docs = await fbStore
          .collection("snacks")
          .where("upc_extra", arrayContains: upc)
          .limit(1)
          .get();
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
        (doc.data()["computed"] != null)
            ? SnackRating(
                toDouble(doc.data()["computed"]["score_overall"]),
                toDouble(doc.data()["computed"]["score_mouthfeel"]),
                toDouble(doc.data()["computed"]["score_accessibility"]),
                toDouble(doc.data()["computed"]["score_snackability"]),
                toDouble(doc.data()["computed"]["score_saltiness"]),
                toDouble(doc.data()["computed"]["score_sourness"]),
                toDouble(doc.data()["computed"]["score_sweetness"]),
                toDouble(doc.data()["computed"]["score_spicyness"]),
              )
            : SnackRating(null, null, null, null, null, null, null, null),
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

  static Future<List<String>> recentSearches() async {
    return [
      "Cheetos Limon",
      "Gardettos",
      "Goldfish",
      "Pringles BBQ",
      "Pringles Barbeque",
      "Pringles Barbecue",
      "Lays"
    ];
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
    String image;
    try {
      userInDB = await fbStore.collection("users").doc(user.uid).get();
      try {
        image = await fbStorage
            .ref()
            .child("user-profiles")
            .child(user.uid + ".jpg")
            .getDownloadURL();
      } catch (error) {

      }
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
      await prefs.setString("user_bio", userInDB.data()["bio"]);
      await prefs.setString("user_image", image);
      //Return instance
      return SnaxUser(userInDB.get("username"), userInDB.get("name"), user.uid,
          userInDB.data()["bio"], photo: image);
    }
  }

  Future<SnaxUser> getUserInfoLocally() async {
    print("[SnaxBackend] Resorting to local user data, server fetch failed");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user_id")) {
      return SnaxUser(
          prefs.getString("user_username"),
          prefs.getString("user_name"),
          prefs.getString("user_id"),
          prefs.getString("user_bio"),
          photo: prefs.getString("user_image"));
    } else {
      throw "No user data present";
    }
  }

  Future<void> deleteUserInfoLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");
    await prefs.remove("user_username");
    await prefs.remove("user_name");
    await prefs.remove("user_bio");
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
