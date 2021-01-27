import 'package:flutter/material.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:sup/quick_sup.dart';

class ReviewedTab extends StatefulWidget {
  SnaxUser user;
  ReviewedTab(this.user);
  @override
  _ReviewedTabState createState() => _ReviewedTabState();
}

class _ReviewedTabState extends State<ReviewedTab> {
  // SnackItem chosenSnack;
  // SnackRating rating;

  // void getReviews() {
  //   SnaxBackend.postReview(chosenSnack.id, rating).then((_) {
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Container(
        //     padding: EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       boxShadow: [
        //         BoxShadow(
        //           color: Color.fromARGB(60, 0, 0, 0),
        //           blurRadius: 8,
        //         )
        //       ],
        //       borderRadius: BorderRadius.circular(12),
        //       color: Theme.of(context).canvasColor,
        //     ),
        //     child: Row(
        //       children: [Text("this")],
        //     ),
        //   ),
        // );
        Padding(
      padding: const EdgeInsets.only(top: 44),
      child: QuickSup.error(
        image: Center(child: Text("🚧", style: TextStyle(fontSize: 32))),
        title: "Coming Soon",
        subtitle: "The Reviewed tab is currently under construction",
      ),
    );
  }
}
