import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/helpers.dart';

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
        }));
  }

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                SnaxBackend.feedMakePost(
                        titleController.text, bodyController.text, snack.id)
                    .then((_) {
                  print("sent");
                  Navigator.pop(context);
                }).catchError((error) {
                  print("error");
                });
              },
              child: Row(
                children: [
                  Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
                height: 250,
                decoration: BoxDecoration(
                  //color: SnaxColors.redAccent,
                  gradient: SnaxGradients.redBigThings,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 180),
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
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image.network(
                                      snack.image,
                                      scale: 3,
                                    )),
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
                              hintText: 'What\'s your opinion on this snack?'),
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
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 18),
              child: Text(
                "Feeling Snacky?",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 38,
                    color: Colors.white),
              ),
            )
          ],
        )
        //   children: [
        //     (snack == null)
        //         ? ListTile(
        //             title: Text("Choose Snack"),
        //             trailing: Icon(Icons.arrow_drop_down_rounded),
        //             onTap: chooseNewSnack,
        //           )
        //         : ListTile(
        //             leading: AspectRatio(
        //                 aspectRatio: 1.0,
        //                 child: Image.network(
        //                   snack.image,
        //                   scale: 5,
        //                 )),
        //             title: Text(snack.name),
        //             subtitle: Text("Choose Other Snack"),
        //             trailing: Icon(Icons.arrow_drop_down_outlined),
        //             onTap: chooseNewSnack),
        //     TextField(
        //       decoration: InputDecoration(
        //           border: InputBorder.none,
        //           contentPadding: EdgeInsets.all(16.0),
        //           hintText: 'Post Title'),
        //       controller: titleController,
        //       minLines: 1,
        //       maxLines: 2,
        //     ),
        //     Expanded(
        //       child: TextField(
        //         decoration: InputDecoration(
        //             border: InputBorder.none,
        //             contentPadding: EdgeInsets.all(16.0),
        //             hintText: 'What\'s your opinion on this snack?'),
        //         controller: bodyController,
        //         minLines: 1,
        //         maxLines: 20,
        //       ),
        //     )
        //   ],
        // ),
        );
  }
}
