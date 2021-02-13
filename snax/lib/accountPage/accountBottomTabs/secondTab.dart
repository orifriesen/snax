import 'package:flutter/material.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/homePage/specificSnack.dart';
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
  List<SnackUserRating> rating;

  void getReviews() {
    SnaxBackend.getRecentReviewsForUser(this.widget.user).then((newRatings) {
      setState(() {
        this.rating = newRatings;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return rating != null
        ? rating.length > 0
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rating.length,
                padding: EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  SnackUserRating ratings = rating[index];
                  return reviewCards(ratings);
                },
              )
            : Padding(
                padding: EdgeInsets.only(top: 44),
                child: QuickSup.empty(
                  title: "No Reviews",
                  subtitle: "@" +
                      this.widget.user.username +
                      " hasn't been reviewing any snacks",
                ))
        : Container(
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(SnaxColors.redAccent),
              ),
            ),
          );
  }

  Widget reviewCards(SnackUserRating ratings) {
    return GestureDetector(
      onTap: () {
        openSpecificSnack(ratings);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 8,
          right: 16,
          bottom: 16,
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(36, 0, 0, 0), blurRadius: 12)
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
              color: isDark(context) ? null : Theme.of(context).canvasColor),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.all(4),
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(ratings.snack.image)),
              ),
              title: Text(
                "${ratings.snack.name}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Text("${ratings.overall}"),
                  SizedBox(width: 5),
                  SmoothStarRating(
                    allowHalfRating: true,
                    starCount: 5,
                    rating: ratings.overall,
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
                  openSpecificSnack(ratings),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openSpecificSnack(SnackUserRating ratings) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductPage(item: ratings.snack)));
  }
}
