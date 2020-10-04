import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/snackList.dart';
import 'snackList.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.item}) : super(key: key);
  final TrendingSnackList item;

  final items = TrendingSnackList.getProducts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.item.name),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
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
                              child: Image.asset("assets/" + this.item.image,
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
                                child: Text(this.item.categories,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue[400])))
                          ],
                        )),
                  ],
                )),
            Container(
                padding: EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Overall Rating:  ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16)),
                      Text(this.item.rating.toStringAsFixed(1) + " ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 24)),
                      SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.rating,
                          size: 28,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 0.0)
                    ])),
            Text(this.item.totalRatings.toString() + " Total Ratings",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
          ],
        ));
  }
}
