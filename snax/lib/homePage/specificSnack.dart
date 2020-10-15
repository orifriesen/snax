import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/snackList.dart';
import 'snackList.dart';

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SnackSearch()));
                }),
            IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SnackSearch()));
                })
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: Align(
                              alignment: Alignment.center,
                              widthFactor: .66,
                              heightFactor: 1.0,
                              child: Image.asset("assets/placeholderImage.jpg",
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
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue[400])))
                          ],
                        )),
                  ],
                )),
            Container(
                padding: EdgeInsets.fromLTRB(32, 16, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Ratings ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Icon(Icons.info_outline, size: 20, color: Colors.grey)
                    ])),
            Container(
                padding: EdgeInsets.all(8),
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
            Text(display(this.item.numberOfRatings) + " Total Ratings",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.grey[600])),
            Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(2),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Sweetness:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .sweetness
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: this.item.averageRatings.sweetness,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Sourness:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .sourness
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: this.item.averageRatings.sourness,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Saltiness:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .saltiness
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: this.item.averageRatings.saltiness,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Spiciness:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .spicyness
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: this.item.averageRatings.spicyness,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Mouthfeel:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .mouthfeel
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: this.item.averageRatings.mouthfeel,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Accessibility:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .accessibility
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating:
                                      this.item.averageRatings.accessibility,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                        Container(
                            padding: EdgeInsets.all(8),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Snackability:  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  Text(
                                      this
                                              .item
                                              .averageRatings
                                              .snackability
                                              .toStringAsFixed(1) +
                                          " ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                ],
                              ),
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: this.item.averageRatings.snackability,
                                  size: 16,
                                  isReadOnly: true,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0.0)
                            ])),
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
