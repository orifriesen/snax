import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/helpers.dart';
import 'package:snax/themes.dart';

class MakePostPage extends StatefulWidget {
  @override
  _MakePostPageState createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  SnackSearchResultItem snack;
  void chooseNewSnack() {
    showSearch(
        context: context,
        delegate: BarcodeAddSearch((SnackSearchResultItem returnSnack) {
          setState(() {
            this.snack = returnSnack;
          });
        }, popOnCallback: true));
  }

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  final prompt = postPrompt();

  bool keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: getTheme(context).appBarBrightness(),
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                SnaxBackend.feedMakePost(
                        titleController.text, bodyController.text, snack.id)
                    .then((_) {
                  print("sent");
                  Fluttertoast.showToast(msg: "Post Sent");
                }).catchError((error) {
                  Fluttertoast.showToast(msg: "An error occurred");
                });
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(
                    "Post",
                    style: TextStyle(
                        color: getTheme(context).appBarContrastForText(),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Icon(
                      Icons.send_rounded,
                      color: getTheme(context).appBarContrastForText(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            // Background Gradient
            Container(
                child: SafeArea(
                    child: Container(
                  height: 80,
                )),
                height: 250,
                decoration: BoxDecoration(
                  gradient: getTheme(context).bigGradient(),
                )),
            // Prompt Text
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 22, left: 18),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  opacity: keyboardIsVisible() ? 0.0 : 1.0,
                  child: Text(
                    prompt,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 38,
                        color: getTheme(context).appBarContrastForText(),),
                  ),
                ),
              ),
            ),
            // Post info card
            SafeArea(
              bottom: false,
              child: AnimatedPadding(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
                padding: EdgeInsets.only(top: keyboardIsVisible() ? 28 : 116),
                child: Container(
                  height: 1000,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)),
                    color: Theme.of(context).canvasColor,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(46, 0, 0, 0), blurRadius: 12)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        (snack == null)
                            ? ListTile(
                                title: Text(
                                  "Choose Snack",
                                  style: TextStyle(fontSize: 18),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                ),
                                onTap: chooseNewSnack,
                              )
                            : ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  clipBehavior: Clip.hardEdge,
                                  padding: EdgeInsets.all(2),
                                  height: 64,
                                  width: 58,
                                  child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Image.network(snack.image)),
                                ),
                                title: Text(
                                  snack.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  "Change Snack",
                                  style: TextStyle(fontSize: 15),
                                ),
                                trailing: Icon(Icons.arrow_drop_down_outlined),
                                onTap: chooseNewSnack),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                                hintText: 'Post Title'),
                            controller: titleController,
                            minLines: 1,
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                                hintText:
                                    'What\'s your opinion on this snack?'),
                            controller: bodyController,
                            minLines: 1,
                            maxLines: 20,
                            maxLength: 500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

String postPrompt() {
  List<String> prompts = ["Feeling Snacky?", "Snacking?", "Got Munchies?"];
  return (prompts..shuffle()).first;
}
