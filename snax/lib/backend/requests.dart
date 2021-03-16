import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart' as material;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiver/iterables.dart';
import 'package:snax/backend/caching.dart';
import 'package:snax/feedPage/post.dart';
import 'package:snax/main.dart';

import 'package:snax/main.dart';
import 'package:snax/tabs.dart';

import 'backend.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:snax/loginPage/loginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image/image.dart';

import 'package:path_provider/path_provider.dart';

import 'package:hive/hive.dart';

//Cache the snack types, references aren't fetched in these requests so this map will be used.
//Example of what it looks like: { "candy-bar": "Candy Bar", "snack-mix": "Snack Mix" }
Map _snackTypes = {};

//Lazy (but way faster) way to get images from our firebase storage. If the image requires authentication this won't work.
String snackImageURL(String id) =>
    "https://firebasestorage.googleapis.com/v0/b/snax-dde4e.appspot.com/o/snacks%2F$id.jpg?alt=media";
String userImageURL(String uid) => uid != null
    ? "https://firebasestorage.googleapis.com/v0/b/snax-dde4e.appspot.com/o/user-profiles%2F$uid.jpg?alt=media"
    : null;
String snackBannerImageURL(String id) =>
    "https://firebasestorage.googleapis.com/v0/b/snax-dde4e.appspot.com/o/snacks-banners%2F$id.png?alt=media";

//Sorting options. Make sure to add it to the SortRawStrings extension if you add a new sort here.
enum SnackListSort { top, trending }

extension SortRawStrings on SnackListSort {
  String get raw {
    switch (this) {
      case SnackListSort.top:
        return "computed.score_overall";
      case SnackListSort.trending:
        return "computed_trend";
      default:
        return null;
    }
  }
}

class SnaxBackend {
  static SnaxUser currentUser;

  // Top rated snacks of all time
  static Future<List<SnackItem>> chartTop(
      {int limit = 25, bool forceRefresh = false}) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));

    return await SnaxBackend._queryAllSnacks(
        fbStore
            .collection("snacks")
            .orderBy("computed.score_overall", descending: true)
            .limit(limit),
        forceRefresh);
  }

  // Snacks with most reviews in the last week
  static Future<List<SnackItem>> chartTrending(
      {int limit = 25, bool forceRefresh = false}) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));
    return await SnaxBackend._queryAllSnacks(
        fbStore
            .collection("snacks")
            .orderBy("computed_trend", descending: true)
            .limit(limit),
        forceRefresh);
  }

  // Snack of the week
  static Future<SnackItem> snackOfTheWeek({bool forceRefresh = false}) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));
    return (await SnaxBackend._queryAllSnacks(
            fbStore
                .collection("snacks")
                .orderBy("isSnackOfTheWeek", descending: true)
                .limit(1),
            forceRefresh))
        .first;
  }

  static Future<List<SnackItem>> getSnacksInCategory(
      String catId, SnackListSort sort,
      {int limit = 25, bool forceRefresh = false}) async {
    //Wait for the firebase to be initiated
    print(sort.raw);
    await waitWhile(() => (fbStore == null));
    return await SnaxBackend._queryAllSnacks(
        fbStore
            .collection("snacks")
            .where("type",
                isEqualTo: fbStore.collection("snack-types").doc(catId))
            .orderBy(sort.raw, descending: true)
            .limit(limit),
        forceRefresh);
  }

  static Future<SnackItem> getSnack(String id) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));
    //Make request
    DocumentSnapshot doc = await fbStore.collection("snacks").doc(id).get();
    //Fetch the snack types (if they don't already exist)
    if (_snackTypes.keys.length == 0) {
      (await fbStore.collection("snack-types").get()).docs.forEach((d) {
        _snackTypes[d.id] = d.get("name");
      });
    }
    //Grab the id of the snack type
    String snackTypeId = (doc.get("type") as DocumentReference).id;
    //Get the banner
    // String bannerUrl;
    // try {
    //   bannerUrl = await fbStorage
    //       .ref()
    //       .child("snacks-banners")
    //       .child(doc.id + ".png")
    //       .getDownloadURL();
    // } catch (error) {
    //   // fetch image error
    // }
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
        snackImageURL(doc.id),
        banner: snackBannerImageURL(doc.id));
  }

  // Private function for getting list of snacks with a sort and limit
  static Future<List<SnackItem>> _queryAllSnacks(
      Query query, bool forceRefresh) async {
    //Check cache for value
    if (!forceRefresh && Cache.has(query.parameters.toString()))
      return (Cache.fetch(query.parameters.toString()) as List<SnackItem>)
          .map((e) {
        e.resetTransitionId();
        return e;
      }).toList();
    // String sort, bool desc, int limit) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));
    //Get the results, ordered by overall score, with an optional limit.
    List<QueryDocumentSnapshot> results = (await query.get()).docs;
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
      //Get banner
      // String bannerUrl;
      // try {
      //   bannerUrl = await fbStorage
      //       .ref()
      //       .child("snacks-banners")
      //       .child(doc.id + ".png")
      //       .getDownloadURL();
      // } catch (error) {
      //   // fetch image error
      // }
      //Return the snack
      snacks.add(SnackItem(
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
          snackImageURL(doc.id),
          banner: snackBannerImageURL(doc.id)));
    }
    Cache.add(query.parameters.toString(), snacks);
    //Return the mapped data
    return snacks;
  }

  static Future<bool> hasReviewedSnack(String id) async {
    //Not logged in
    if (SnaxBackend.currentUser == null) return false;
    //Check
    return (await fbStore
                .collection("snacks")
                .doc(id)
                .collection("ratings")
                .where("uid", isEqualTo: SnaxBackend.currentUser.uid)
                .limit(1)
                .get())
            .size >
        0;
  }

  //This random string is being used as an alternative to 'undefined' which doesnt exist in dart
  static const _undefinedBioString = "zX43XBOZ7PtzulR";

  static Future<void> updateProfile(
      {String username, String name, String bio = _undefinedBioString}) async {
    if (username == SnaxBackend.currentUser.username) username = null;
    if (name == SnaxBackend.currentUser.name) name = null;
    if (bio == SnaxBackend.currentUser.bio) bio = _undefinedBioString;
    if (bio == "") bio = null;

    Map<String, String> params = {};
    if (username != null) {
      params["username"] = username;
      SnaxBackend.currentUser.username = username;
    }
    if (name != null) {
      params["name"] = name;
      SnaxBackend.currentUser.name = name;
    }
    if (bio != _undefinedBioString) {
      params["bio"] = bio;
      SnaxBackend.currentUser.bio = bio;
    }
    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    await waitWhile(() => (currentUser == null));

    params["token"] = token;

    //Send request
    HttpsCallableResult result =
        await fbCloud.httpsCallable("updateProfile").call(params);

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
    //String token = await fbAuth.currentUser.getIdToken();
    String uid = fbAuth.currentUser.uid;

    //Resize and reformat image
    Image image = decodeImage(await pickedFile.readAsBytes());
    Image resized = copyResize(image, width: 400, height: 400);
    io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    io.File file = io.File(appDocDirectory.path + '/$uid.jpg');
    await file.writeAsBytes(encodeJpg(resized));

    try {
      var task = await fbStorage
          .ref()
          .child("user-profiles")
          .child(uid + ".jpg")
          .putFile(file);
      SnaxBackend.currentUser.photo = await task.ref.getDownloadURL();
    } catch (error) {
      print(error);
      throw "Failed to upload";
    }
  }

  static Future<void> followUser(String uid) async {
    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    HttpsCallableResult result = await fbCloud
        .httpsCallable("followUser")
        .call({"token": token, "uid": uid});

    if (result.data["status"] != "success") throw result.data["error"];

    //Add to local database
    var followingBox = await Hive.openBox('user_following');
    followingBox.add(uid);
    // await Hive.close();
  }

  static Future<void> unfollowUser(String uid) async {
    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    HttpsCallableResult result = await fbCloud
        .httpsCallable("unfollowUser")
        .call({"token": token, "uid": uid});

    if (result.data["status"] != "success") throw result.data["error"];

    //Remove from local database
    var followingBox = await Hive.openBox('user_following');
    if (followingBox.values.toList().indexOf(uid) > 0)
      followingBox.deleteAt(followingBox.values.toList().indexOf(uid));
    // await Hive.close();
  }

  static Future<List<SnaxUser>> getFollowers(String uid) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));
    //Get the list of ids
    List<String> userIds = (await fbStore
            .collection("users")
            .doc(uid)
            .collection("followers")
            .get())
        .docs
        .map((e) => e.id)
        .toList();
    if (userIds.length == 0) return [];
    //Partition the groups of 10 (the limit for Firebase)
    List<List<String>> uidGroups = partition(userIds, 10).toList();
    //Collect the results
    List<QueryDocumentSnapshot> userDocs = [];
    List<QuerySnapshot> groupResults = (await Future.wait(uidGroups.map((g) =>
        (fbStore
            .collection("users")
            .where(FieldPath.documentId, whereIn: g)
            .get()))))
      ..forEach((group) {
        userDocs.addAll(group.docs);
      });
    //Open the box
    var followingBox = await Hive.openBox('user_following');
    //Make the list
    List<SnaxUser> users = [];
    for (var doc in userDocs) {
      users.add(SnaxUser(
          doc.get("username"),
          doc.get("name"),
          doc.id,
          doc.data()["bio"],
          doc.get("followerCount"),
          doc.get("followingCount"),
          doc.data()["verified"] ?? false,
          photo:
              (doc.data()["hasPhoto"] ?? false) ? userImageURL(doc.id) : null,
          userIsFollowing: followingBox.values.contains(doc.id)));
    }
    // await Hive.close();
    return users;
  }

  // static Future<String> getUserImage(uid) async {
  //   var ref = fbStorage.ref().child("user-profiles").child(uid + ".jpg");
  //   try {
  //     return await ref.getDownloadURL();
  //   } catch (_) {
  //     print(
  //         "ignore previous firebase storage error, it was just a user without a profile photo");
  //     return null;
  //   }
  // }

  static Future<List<SnaxUser>> getFollowing(String uid) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));
    //Get the list of ids
    List<String> userIds = (await fbStore
            .collection("users")
            .doc(uid)
            .collection("following")
            .get())
        .docs
        .map((e) => e.id)
        .toList();
    if (userIds.length == 0) return [];
    //Partition the groups of 10 (the limit for Firebase)
    List<List<String>> uidGroups = partition(userIds, 10).toList();
    //Collect the results
    List<QueryDocumentSnapshot> userDocs = [];
    List<QuerySnapshot> groupResults = (await Future.wait(uidGroups.map((g) =>
        (fbStore
            .collection("users")
            .where(FieldPath.documentId, whereIn: g)
            .get()))))
      ..forEach((group) {
        userDocs.addAll(group.docs);
      });
    //Open the box
    var followingBox = await Hive.openBox('user_following');
    print(followingBox.values);
    //Make the list
    List<SnaxUser> users = [];
    for (var doc in userDocs) {
      users.add(SnaxUser(
          doc.get("username"),
          doc.get("name"),
          doc.id,
          doc.data()["bio"],
          doc.get("followerCount"),
          doc.get("followingCount"),
          doc.data()["verified"] ?? false,
          photo:
              (doc.data()["hasPhoto"] ?? false) ? userImageURL(doc.id) : null,
          userIsFollowing: followingBox.values.contains(doc.id)));
    }
    // await Hive.close();
    return users;
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
        .httpsCallable("feedMakePost")
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

  static Future<void> feedLikeComment(
      String postId, String commentId, bool like) async {
    if (commentId == null || postId == null) {
      throw "Missing Data";
    }

    //Login
    await SnaxBackend.auth.loginIfNotAlready();
    //Get token
    String token = await fbAuth.currentUser.getIdToken();

    //Send request
    HttpsCallableResult result = await fbCloud.httpsCallable("feedLike").call({
      "post_id": postId,
      "comment_id": commentId,
      "token": token,
      "unlike": !like
    });

    if (result.data["status"] != "success") throw result.data["error"];

    //Add to local database
    var likeBox = await Hive.openBox('user_likes');
    like
        ? likeBox.put(postId + "." + commentId, true)
        : likeBox.delete(postId + "." + commentId);
    // await Hive.close();
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
        .httpsCallable("feedLike")
        .call({"post_id": postId, "token": token, "unlike": !like});

    print(result.data);

    if (result.data["status"] != "success") throw result.data["error"];

    //Add to local database
    var likeBox = await Hive.openBox('user_likes');
    like ? likeBox.put(postId, true) : likeBox.delete(postId);
    // await likeBox.close();
  }

  static Future<Post> feedGetPost(String id,
      {bool forceRefresh = false}) async {
    //Wait for firebase init
    await waitWhile(() => (fbStore == null));
    var query = fbStore.collection("feed").doc(id);
    //Check the cache
    if (!forceRefresh && Cache.has(query.toString()))
      return Cache.fetch(query.toString());
    //Fetch
    DocumentSnapshot result = await query.get();
    if (!result.exists) throw "Post Not Found";
    //Make into post
    var post = (await _feedGrabRefs([result].toList())).first;
    //Add to cache
    Cache.add(query.toString(), post);
    return post;
  }

  static Future<List<Post>> feedGetTopPosts({bool forceRefresh = false}) async {
    //Wait for firebase init
    await waitWhile(() => (fbStore == null));
    var query =
        fbStore.collection("feed").orderBy("likes", descending: true).limit(25);
    //Check cache before actually fetching
    if (!forceRefresh && Cache.has(query.parameters.toString()))
      return Cache.fetch(query.parameters.toString());
    //Actually fetch
    List<QueryDocumentSnapshot> docs = (await query.get()).docs;
    var results = docs.isNotEmpty ? await _feedGrabRefs(docs) : [];
    //Add to cache
    Cache.add(query.parameters.toString(), results);
    return results;
  }

  static Future<List<Post>> feedGetRecentFriendPosts(
      {bool forceRefresh = false}) async {
    //Wait for firebase init
    await waitWhile(() => (fbStore == null));
    await auth.loginIfNotAlready();
    var followingBox = await Hive.openBox('user_following');
    if (followingBox.keys.isEmpty) return [];

    int amountToFetch = 30;

    List<List<dynamic>> uidGroups =
        partition(followingBox.values.toList(), 10).toList();

    var cacheKey = "feed_friends:" + followingBox.values.join("-");
    //Check cache before actually fetching
    if (!forceRefresh && Cache.has(cacheKey)) return Cache.fetch(cacheKey);
    //Actually fetch
    List<QueryDocumentSnapshot> docs = [];
    (await Future.wait(uidGroups.map((g) => fbStore
            .collection("feed")
            .where("uid", whereIn: g)
            .orderBy("timestamp", descending: true)
            .limit((amountToFetch / uidGroups.length).floor())
            .get())))
        .forEach((result) {
      docs.addAll(result.docs);
    });
    //Restore the sort
    docs.sort((a, b) {
      int ta = a.data()["timestamp"];
      int tb = b.data()["timestamp"];
      return tb.compareTo(ta);
    });
    var results = docs.isNotEmpty ? await _feedGrabRefs(docs) : [];
    //Add to cache
    Cache.add(cacheKey, results);
    return results;
  }

  static Future<List<Post>> feedGetTrendingPosts(
      {bool forceRefresh = false}) async {
    //Wait for firebase init
    await waitWhile(() => (fbStore == null));
    var query =
        fbStore.collection("feed").orderBy("score", descending: true).limit(25);
    //Check cache before actually fetching
    if (!forceRefresh && Cache.has(query.parameters.toString()))
      return Cache.fetch(query.parameters.toString());
    List<QueryDocumentSnapshot> docs = (await query.get()).docs;
    var results = docs.isNotEmpty ? await _feedGrabRefs(docs) : [];
    //Add to cache
    Cache.add(query.parameters.toString(), results);
    return results;
  }

  static Future<List<Post>> feedGetTopPostsForSnack(String snackId) async {
    await waitWhile(() => (fbStore == null));
    List<QueryDocumentSnapshot> docs = (await fbStore
            .collection("feed")
            .where("snack_id", isEqualTo: snackId)
            .orderBy("likes", descending: true)
            .limit(25)
            .get())
        .docs;
    return docs.isNotEmpty ? await _feedGrabRefs(docs) : [];
  }

  static Future<List<Post>> feedGetRecentPostsForUser(String uid) async {
    await waitWhile(() => (fbStore == null));
    List<QueryDocumentSnapshot> docs = (await fbStore
            .collection("feed")
            .where("uid", isEqualTo: uid)
            .orderBy("timestamp", descending: true)
            .limit(25)
            .get())
        .docs;
    return docs.isNotEmpty ? await _feedGrabRefs(docs) : [];
  }

  static Future<List<SnackUserRating>> getRecentReviewsForUser(SnaxUser user,
      {int limit = 10}) async {
    await waitWhile(() => (fbStore == null));
    List<QueryDocumentSnapshot> docs = (await fbStore
            .collectionGroup("ratings")
            .where("user_id", isEqualTo: user.uid)
            .orderBy("timestamp", descending: true)
            .get())
        .docs;
    List<DocumentReference> snackRefs =
        docs.map((element) => element.reference.parent.parent).toList();
    //Get the snacks
    List<QueryDocumentSnapshot> snackDocs = [];
    (await Future.wait(partition(snackRefs, 10).map((e) => fbStore
            .collection("snacks")
            .where(FieldPath.documentId, whereIn: e.map((m) => m.id).toList())
            .get())))
        .forEach((element) {
      snackDocs.addAll(element.docs);
    });
    //Return the data
    return snackDocs
        .asMap()
        .entries
        .map((e) => SnackUserRating(
            user,
            SnackItem(
                e.value.data()["name"],
                e.value.id,
                SnackItemType(
                    _snackTypes[
                        (e.value.data()["type"] as DocumentReference).id],
                    (e.value.data()["type"] as DocumentReference).id),
                e.value.data()["upc"],
                (e.value.data()["computed"] != null)
                    ? SnackRating(
                        toDouble(e.value.get("computed.score_overall")),
                        toDouble(e.value.get("computed.score_mouthfeel")),
                        toDouble(e.value.get("computed.score_accessibility")),
                        toDouble(e.value.get("computed.score_snackability")),
                        toDouble(e.value.get("computed.score_saltiness")),
                        toDouble(e.value.get("computed.score_sourness")),
                        toDouble(e.value.get("computed.score_sweetness")),
                        toDouble(e.value.get("computed.score_spicyness")),
                      )
                    : null,
                e.value.data()["computed_ratings"],
                e.value.data()["computed_trend"],
                snackImageURL(e.value.id)),
            toDouble(docs[e.key].get("ratings.score_overall")),
            toDouble(docs[e.key].get("ratings.score_mouthfeel")),
            toDouble(docs[e.key].get("ratings.score_accessibility")),
            toDouble(docs[e.key].get("ratings.score_snackability")),
            toDouble(docs[e.key].get("ratings.score_saltiness")),
            toDouble(docs[e.key].get("ratings.score_sourness")),
            toDouble(docs[e.key].get("ratings.score_sweetness")),
            toDouble(docs[e.key].get("ratings.score_spicyness"))))
        .toList();
  }

  static Future<List<Comment>> feedGetComments(String postId) async {
    //Wait for firebase init
    await waitWhile(() => (fbStore == null));
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
        .httpsCallable("feedMakeComment")
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
    //Get local list of likes
    var likeBox = await Hive.openBox('user_likes');
    var followingBox = await Hive.openBox('user_following');
    //Create an empty list and add all the user ids
    List<String> userIds = [];
    docs.forEach((doc) {
      //Add user id
      if (!userIds.contains(doc.data()["uid"])) userIds.add(doc.data()["uid"]);
    });
    //Get all the users

    List<QueryDocumentSnapshot> userDocs = [];
    (await Future.wait(partition(userIds, 10).map((e) => fbStore
            .collection("users")
            .where(FieldPath.documentId, whereIn: e)
            .get())))
        .forEach((element) {
      userDocs.addAll(element.docs);
    });
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
          userDatas[data["uid"]]["bio"],
          userDatas[data["uid"]]["followerCount"],
          userDatas[data["uid"]]["followingCount"],
          userDatas[data["uid"]]["verified"] ?? false,
          photo: (userDatas[data["uid"]]["hasPhoto"] ?? false)
              ? userImageURL(data["uid"])
              : null,
          userIsFollowing: followingBox.values.contains(data["uid"]));
      comments.add(Comment(
          doc.id,
          postId,
          user,
          data["content"],
          DateTime.fromMillisecondsSinceEpoch(data["timestamp"]),
          data["likes"] ?? 0,
          likedByMe: likeBox.containsKey(postId + "." + doc.id)));
    }
    // await Hive.close();
    return comments;
  }

  //Grab extra info like user and snack for a given list of feed database items
  static Future<List<Post>> _feedGrabRefs(List<dynamic> docs) async {
    //Get local list of likes
    var likeBox = await Hive.openBox('user_likes');
    var followingBox = await Hive.openBox('user_following');
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
    List<QueryDocumentSnapshot> snackResults = [];
    List<QueryDocumentSnapshot> userResults = [];
    var futureResults = (await Future.wait([
      Future.wait(partition(snackIds, 10).map((r) => fbStore
          .collection("snacks")
          .where(FieldPath.documentId, whereIn: r)
          .get())),
      Future.wait(partition(userIds, 10).map((r) => fbStore
          .collection("users")
          .where(FieldPath.documentId, whereIn: r)
          .get())),
    ]));
    futureResults[0].forEach((snackGroup) {
      snackResults.addAll(snackGroup.docs);
    });
    futureResults[1].forEach((userGroup) {
      userResults.addAll(userGroup.docs);
    });

    // List<QuerySnapshot> results = await Future.wait([
    //   fbStore
    //       .collection("snacks")
    //       .where(FieldPath.documentId, whereIn: snackIds)
    //       .get(),
    //   fbStore
    //       .collection("users")
    //       .where(FieldPath.documentId, whereIn: userIds)
    //       .get()
    // ]);
    //Organize the data
    Map<String, Map> snackDatas = {};
    snackResults.forEach((e) {
      snackDatas[e.id] = e.data();
    });
    Map<String, Map> userDatas = {};
    userResults.forEach((e) {
      userDatas[e.id] = e.data();
    });
    //Create posts
    List<Post> posts = [];
    for (var doc in docs) {
      var data = doc.data();
      if (!snackDatas.containsKey(data["snack_id"]) ||
          !userDatas.containsKey(data["uid"])) continue;

      //Create user
      SnaxUser user = SnaxUser(
          userDatas[data["uid"]]["username"],
          userDatas[data["uid"]]["name"],
          data["uid"],
          userDatas[data["uid"]]["bio"],
          userDatas[data["uid"]]["followerCount"],
          userDatas[data["uid"]]["followingCount"],
          userDatas[data["uid"]]["verified"] ?? false,
          photo: (userDatas[data["uid"]]["hasPhoto"] ?? false)
              ? userImageURL(data["uid"])
              : null,
          userIsFollowing: followingBox.values.contains(data["uid"]));

      //Create snack
      SnackSearchResultItem snack = SnackSearchResultItem(
          snackDatas[data["snack_id"]]["name"],
          data["snack_id"],
          snackDatas[data["snack_id"]]["computed_ratings"],
          toDouble((snackDatas[data["snack_id"]]["computed"] ??
              {"score_overall": null})["score_overall"]),
          snackImageURL(data["snack_id"]));
      //Add post
      posts.add(Post(
          doc.id,
          user,
          snack,
          data["post_title"],
          data["post_body"],
          DateTime.fromMillisecondsSinceEpoch(data["timestamp"]),
          data["likes"],
          data["comments"],
          likedByMe: likeBox.containsKey(doc.id)));
    }
    // await Hive.close();
    return posts;
  }

  static Future<void> addUpc(int upc, String snackId) async {
    //Wait for the cloud functions client to be initiated
    await waitWhile(() => (fbCloud == null));
    //Call search function from database
    HttpsCallableResult result = await fbCloud
        .httpsCallable("addUserUpc")
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
    await waitWhile(() => (fbStore == null));
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
        snackImageURL(doc.id));
  }

  static Future<List<SnaxUser>> searchUsers(String query) async {
    //Wait for the cloud functions client to be initiated
    await waitWhile(() => (fbCloud == null));
    //Call search function from database
    HttpsCallableResult result =
        await fbCloud.httpsCallable("searchUsers").call({"q": query.trim()});
    //Parse
    if (result.data["status"] == "success") {
      //Get following list
      var followingBox = await Hive.openBox('user_following');
      //Create the results list and an empty classed list
      List resultItems = result.data["results"];
      List<SnaxUser> returnItems = [];
      //Iterate through search results
      for (var result in resultItems) {
        //Add to the list
        returnItems.add(SnaxUser(
            result["data"]["username"],
            result["data"]["name"],
            result["id"],
            result["data"]["bio"],
            result["data"]["followerCount"],
            result["data"]["followingCount"],
            result["data"]["verified"] ?? false,
            photo: (result["data"]["hasPhoto"] ?? false)
                ? userImageURL(result["id"])
                : null,
            userIsFollowing: followingBox.values.contains(result["id"])));
      }
      // await Hive.close();
      //Return the list
      return returnItems;
    } else if (result.data["error"] != null) {
      throw result.data["error"];
    } else {
      throw "An unknown error occurred, please try again later";
    }
  }

  static Future<SnaxUser> getUser(String uid) async {
    //Wait for the firebase to be initiated
    await waitWhile(() => (fbStore == null));

    var doc = await fbStore.collection("users").doc(uid).get();

    //Get following list
    var followingBox = await Hive.openBox('user_following');

    return SnaxUser(
        doc.data()["username"],
        doc.data()["name"],
        doc.id,
        doc.data()["bio"],
        doc.data()["followerCount"],
        doc.data()["followingCount"],
        doc.data()["verified"] ?? false,
        userIsFollowing: followingBox.values.contains(doc.id),
        photo: (doc.data()["hasPhoto"] ?? false) ? userImageURL(uid) : null);
  }

  static Future<List<SnackSearchResultItem>> search(String query) async {
    //Wait for the cloud functions client to be initiated
    await waitWhile(() => (fbCloud == null));
    //Call search function from database
    HttpsCallableResult result =
        await fbCloud.httpsCallable("searchSnacks").call({"q": query.trim()});
    //Parse
    if (result.data["status"] == "success") {
      //Create the results list and an empty classed list
      List resultItems = result.data["results"];
      List<SnackSearchResultItem> returnItems = [];
      //Iterate through search results
      for (var result in resultItems) {
        //Add to the list
        returnItems.add(SnackSearchResultItem(
            result["name"].toString(),
            result["id"].toString(),
            (result["count"] != null) ? (result["count"]) as int : null,
            (result["overall"] != null) ? (result["overall"]).toDouble() : null,
            snackImageURL(result["id"].toString())));
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
    await waitWhile(() => (fbAuth == null));
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
        await fbCloud.httpsCallable("rateSnack").call(body);
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
    await waitWhile(() => (loggedIn == null));

    //If the user didnt log in
    if (!loggedIn) throw "You must log in first.";

    print("User Logged in via loginIfNotAlready");

    //Wait for the current user to be fetched from the database and return
    await waitWhile(() => (SnaxBackend.currentUser == null));
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
      } catch (error) {}
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
      await prefs.setString(
          "user_followerCount", userInDB.get("followerCount").toString());
      await prefs.setString(
          "user_followingCount", userInDB.get("followingCount").toString());
      await prefs.setString("user_image", image);
      //Update the likes
      //Get local list of likes
      var likeBox = await Hive.openBox('user_likes');
      List<dynamic> likes = userInDB.get("likes");
      Map<String, bool> likeMap = {};
      likes.forEach((id) {
        likeMap[id] = true;
      });
      await likeBox.putAll(likeMap);
      //Get following
      var followingUids = (await fbStore
              .collection("users")
              .doc(user.uid)
              .collection("following")
              .get())
          .docs
          .map((e) => e.id)
          .toList()
          .asMap();
      var followingBox = await Hive.openBox('user_following');
      print(followingUids);
      await followingBox.clear();
      await followingBox.putAll(followingUids);
      // await followingBox.close();
      //Return instance
      return SnaxUser(
          userInDB.get("username"),
          userInDB.get("name"),
          user.uid,
          userInDB.data()["bio"],
          userInDB.get("followerCount"),
          userInDB.get("followingCount"),
          userInDB.data()["verified"] ?? false,
          photo: image);
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
          int.parse(prefs.getString("user_followerCount")),
          int.parse(prefs.getString("user_followingCount")),
          prefs.containsKey("verified") ? prefs.getBool("verified") : false,
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
    try {
      await Hive.deleteBoxFromDisk("user_likes");
    } catch (error) {}
  }

  Future<void> logOut(
      {restartApp = true, material.BuildContext context}) async {
    await fbAuth.signOut();
    SnaxBackend.currentUser = null;
    await this.deleteUserInfoLocally();
    //if (restartApp) Phoenix.rebirth(context ?? globalContext);
  }

  Future<void> uploadFCMToken(String fcmToken) async {
    //Wait for the cloud functions client to be initiated
    await waitWhile(() => (fbCloud == null));
    if (fbAuth.currentUser == null) throw "Not Logged In";
    //Get token
    String token = await fbAuth.currentUser.getIdToken();
    //Call search function from database
    HttpsCallableResult result = await fbCloud
        .httpsCallable("uploadFCMToken")
        .call({"token": token, "fcm_token": fcmToken});
//Parse
    if (result.data["status"] == "success") {
      return;
    } else if (result.data["error"] != null) {
      print(result.data["raw"]);
      throw result.data["error"];
    } else {
      throw "An unknown error occurred, please try again later";
    }
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

Future waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
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
