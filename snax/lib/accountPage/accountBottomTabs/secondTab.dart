import 'package:flutter/material.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sup/quick_sup.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import '../../helpers.dart';

class ReviewedTab extends StatefulWidget {
  SnaxUser user;
  ReviewedTab(this.user);
  @override
  _ReviewedTabState createState() => _ReviewedTabState();
}

class _ReviewedTabState extends State<ReviewedTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SnaxBackend.getRecentReviewsForUser(this.widget.user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SnackUserRating ratings = snapshot.data;
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            leading: Icon(
              Icons.access_alarm,
              size: 32,
            ),
            title: Text(
              "${ratings.overall}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Text("4.5"),
                SizedBox(width: 5),
                SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: 4.5,
                  size: 18,
                  isReadOnly: true,
                  defaultIconData: Icons.star_border_rounded,
                  filledIconData: Icons.star_rounded,
                  halfFilledIconData: Icons.star_half_rounded,
                  color: SnaxColors.redAccent,
                  borderColor: SnaxColors.redAccent,
                  spacing: 0.0,
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              iconSize: 20,
              onPressed: () => {
                //* Opens up the users complete reviewed categories
              },
            ),
          );
        } else if (snapshot.hasError) {
          print("Failed to load Reviewed tab");
          return Container();
        } else {
          return Container(
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(SnaxColors.redAccent),
              ),
            ),
          );
        }
      },
    );
  }
}
