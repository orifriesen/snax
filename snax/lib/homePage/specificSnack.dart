import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/ratingInfoPage.dart';
import 'package:snax/homePage/userReview.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.item}) : super(key: key);
  final SnackItem item;

  final display = createDisplay(placeholder: '--');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                }),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(48, 16, 16, 16),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          color: Colors.white,
                          child: Align(
                              alignment: Alignment.center,
                              widthFactor: .66,
                              heightFactor: 1.0,
                              child: Image.network(this.item.image,
                                  width: 100, height: 100)),
                        )),
                    Container(
                        padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(this.item.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 24)),
                            Container(
                                padding: EdgeInsets.fromLTRB(4, 4, 0, 0),
                                child: Text(this.item.type.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)))
                          ],
                        )),
                  ],
                )),
            Container(
                padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Ratings",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      IconButton(
                        icon: Icon(Icons.info_outline, size: 24),
                        color: Colors.grey,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RatingInfoPage()));
                        },
                      )
                    ])),
            Container(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Overall:  ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.grey[600])),
                      Text(
                          this.item.averageRatings.overall.toStringAsFixed(1) +
                              " ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 36)),
                      SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.overall,
                          size: 28,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 0.0)
                    ])),
            Center(
              child: Text(display(this.item.numberOfRatings) + " total ratings",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey[600])),
            ),
            Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        displayStarRating(this.item.averageRatings.snackability,
                            "Snackability"),
                        displayStarRating(
                            this.item.averageRatings.mouthfeel, "Mouthfeel"),
                        displayStarRating(
                            this.item.averageRatings.accessibility,
                            "Accessibility")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        displayProgressBarRating(
                            this.item.averageRatings.spicyness,
                            "Spiciness",
                            context),
                        displayProgressBarRating(
                            this.item.averageRatings.sweetness,
                            "Sweetness",
                            context),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        displayProgressBarRating(
                            this.item.averageRatings.sourness,
                            "Sourness",
                            context),
                        displayProgressBarRating(
                            this.item.averageRatings.saltiness,
                            "Saltiness",
                            context),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Center(
                                child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(48, 12, 48, 12),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserReviewPage(
                                              item: this.item,
                                            )));
                              },
                              child: Text(
                                'Review this snack',
                                style: TextStyle(fontSize: 16),
                              ),
                            ))),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}

Widget displayStarRating(double snackItemData, String title) {
  final double data = snackItemData;
  final String inputName = title;
  return Container(
      padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text(inputName + ": ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.grey[600])),
            Text(data.toStringAsFixed(1) + " ",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          ],
        ),
        SmoothStarRating(
            allowHalfRating: true,
            starCount: 5,
            rating: data,
            size: 18,
            isReadOnly: true,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            color: Colors.amber,
            borderColor: Colors.amber,
            spacing: 0.0)
      ]));
}

Widget displayProgressBarRating(
    double snackItemData, String title, BuildContext context) {
  final double data = snackItemData;
  final String inputName = title;

  return Container(
      padding: EdgeInsets.all(8),
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text(inputName + ": ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.grey[600])),
            Text(data.toStringAsFixed(1) + " ",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          ],
        ),
        LinearPercentIndicator(
          width: 100.0,
          lineHeight: 8.0,
          percent: data / 5,
          progressColor: Theme.of(context).accentColor,
          backgroundColor: Colors.grey[200],
          animation: true,
          animationDuration: 500,
        )
      ]));
}
