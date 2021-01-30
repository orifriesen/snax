import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:snax/backend/backend.dart';
import 'package:sup/quick_sup.dart';
import '../../helpers.dart';

class ReviewedTab extends StatefulWidget {
  SnaxUser user;
  ReviewedTab(this.user);
  @override
  _ReviewedTabState createState() => _ReviewedTabState();
}

//todo Make the function return users reviews
class _ReviewedTabState extends State<ReviewedTab> {
  SnackItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(60, 0, 0, 0),
              blurRadius: 8,
            )
          ],
          borderRadius: BorderRadius.circular(18),
          gradient: isDark(context) ? SnaxGradients.darkGreyCard : null,
          color: Theme.of(context).canvasColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          leading: Icon(
            Icons.access_alarm,
            size: 32,
          ),
          title: Text(
            "This is the name of snack",
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
        ),
      ),
    );
    //     Padding(
    //   padding: const EdgeInsets.only(top: 44),
    //   child: QuickSup.error(
    //     image: Center(child: Text("🚧", style: TextStyle(fontSize: 32))),
    //     title: "Coming Soon",
    //     subtitle: "The Reviewed tab is currently under construction",
    //   ),
    // );
  }
}
