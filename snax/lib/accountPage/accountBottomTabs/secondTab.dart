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
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              SnackUserRating ratings = snapshot.data[index];
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 12)
                    ],
                    gradient: isDark(context)
                        ? LinearGradient(
                            colors: [
                              HexColor.fromHex("3C3C3C"),
                              HexColor.fromHex("2C2C2C")
                            ],
                            begin: Alignment(0, -0.2),
                            end: Alignment(0, 1.5),
                          )
                        : null,
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.network(ratings.snack.image)),
                    title: Text(
                      "${ratings.snack.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Text("${ratings.snackability}"),
                        SizedBox(width: 5),
                        SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: ratings.snackability,
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
                  ),
                ),
              );
            },
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
