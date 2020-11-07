import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:number_display/number_display.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/helpers.dart';
import 'package:snax/homePage/userReview.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.item}) : super(key: key);
  final SnackItem item;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  SnackItem chosenSnack;

  final display = createDisplay(placeholder: '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: BarcodeAddSearch(
                        (SnackSearchResultItem returnSnack) async {
                      chosenSnack = await SnaxBackend.getSnack(returnSnack.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductPage(item: chosenSnack)));
                    }));
              }),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      body: Stack(children: [
        Container(
            child: SafeArea(
                left: false,
                right: false,
                bottom: false,
                child: Container(height: 80)),
            decoration: BoxDecoration(
                color: SnaxColors.redAccent,
                gradient: SnaxGradients.redBigThings,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)))),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SafeArea(
              left: false,
              right: false,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(36, 0, 0, 0),
                              blurRadius: 12)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(this.widget.item.image,
                              width: 80, height: 80),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: Text(
                                    this.widget.item.name,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(
                                    children: [
                                      Text(this.widget.item.type.name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[400])),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                        color: Colors.grey[400],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                      display(this
                                              .widget
                                              .item
                                              .numberOfRatings) +
                                          " total ratings",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[400])),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                this.widget.item.numberOfRatings != 0 &&
                        this.widget.item.numberOfRatings != null
                    ? criteriaList()
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 256,
                          child: Text(
                            "Sorry, this snack has no ratings yet, but you can be the first",
                            style: TextStyle(fontSize: 28, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
              ]),
            )
          ],
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton.extended(
          highlightElevation: 1,
          backgroundColor: SnaxColors.redAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserReviewPage(
                          this.widget.item.id,
                          this.widget.item.name,
                        )));
          },
          label: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Text("Rate Snack", style: TextStyle(fontSize: 18)),
            ),
          )),
    );
  }

  Widget criteriaList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(this.widget.item.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Text(
                      this
                              .widget
                              .item
                              .averageRatings
                              .overall
                              .toStringAsFixed(1) +
                          " ",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: this.widget.item.averageRatings.overall,
                      size: 24,
                      isReadOnly: true,
                      filledIconData: Icons.star_rounded,
                      halfFilledIconData: Icons.star_half_rounded,
                      defaultIconData: Icons.star_outline_rounded,
                      color: SnaxColors.redAccent,
                      borderColor: SnaxColors.redAccent,
                      spacing: 0.0)
                ])),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text("CRITERIA",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
        divider(),
        returnSpecificCriteria(
            "Snackability", this.widget.item.averageRatings.snackability, true),
        divider(),
        returnSpecificCriteria(
            "Mouthfeel", this.widget.item.averageRatings.mouthfeel, true),
        divider(),
        returnSpecificCriteria("Accessibility",
            this.widget.item.averageRatings.accessibility, true),
        divider(),
        returnSpecificCriteria(
            "Sweetness", this.widget.item.averageRatings.sweetness, false),
        divider(),
        returnSpecificCriteria(
            "Saltiness", this.widget.item.averageRatings.saltiness, false),
        divider(),
        returnSpecificCriteria(
            "Sourness", this.widget.item.averageRatings.sourness, false),
        divider(),
        returnSpecificCriteria(
            "Spiciness", this.widget.item.averageRatings.spicyness, false),
      ],
    );
  }

  Widget divider() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Divider(
        color: Colors.grey[600],
        height: 8,
      ),
    );
  }

  Widget returnSpecificCriteria(
      String title, double snackItemData, bool isStar) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Text(snackItemData.toStringAsFixed(1) + " ",
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
              isStar == true
                  ? SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: snackItemData,
                      size: 24,
                      isReadOnly: true,
                      filledIconData: Icons.star_rounded,
                      halfFilledIconData: Icons.star_half_rounded,
                      defaultIconData: Icons.star_outline_rounded,
                      color: SnaxColors.redAccent,
                      borderColor: SnaxColors.redAccent,
                      spacing: 0.0)
                  : Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: LinearPercentIndicator(
                        width: 120.0,
                        lineHeight: 12.0,
                        percent: snackItemData / 5,
                        progressColor: SnaxColors.redAccent,
                        backgroundColor: Colors.grey[200],
                        animation: true,
                        animationDuration: 750,
                      ),
                    )
            ])),
      ]),
    );
  }
}
