import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Stack(children: [
      CustomPaint(
        painter: Sky(),
      ),
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                }),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
          ],
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(this.item.image, width: 80, height: 80),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                this.item.name,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                children: [
                                  Text(this.item.type.name,
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
                                  display(this.item.numberOfRatings) +
                                      " total ratings",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[400])),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 24, left: 16, right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(this.item.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Text(
                            this
                                    .item
                                    .averageRatings
                                    .overall
                                    .toStringAsFixed(1) +
                                " ",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                        SmoothStarRating(
                            allowHalfRating: true,
                            starCount: 5,
                            rating: this.item.averageRatings.overall,
                            size: 24,
                            isReadOnly: true,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            color: Colors.red,
                            borderColor: Colors.red,
                            spacing: 0.0)
                      ])),
                ]),
          ),
          criteriaList()
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserReviewPage(
                            this.item.id,
                            this.item.name,
                          )));
            },
            label: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Text("Rate Snack", style: TextStyle(fontSize: 18)),
            )),
      ),
    ]);
  }

  Widget criteriaList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text("CRITERIA",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
        divider(),
        returnSpecificCriteria(
            "Snackability", this.item.averageRatings.snackability, true),
        divider(),
        returnSpecificCriteria(
            "Mouthfeel", this.item.averageRatings.mouthfeel, true),
        divider(),
        returnSpecificCriteria(
            "Accessibility", this.item.averageRatings.accessibility, true),
        divider(),
        returnSpecificCriteria(
            "Sweetness", this.item.averageRatings.sweetness, false),
        divider(),
        returnSpecificCriteria(
            "Saltiness", this.item.averageRatings.saltiness, false),
        divider(),
        returnSpecificCriteria(
            "Sourness", this.item.averageRatings.sourness, false),
        divider(),
        returnSpecificCriteria(
            "Spiciness", this.item.averageRatings.spicyness, false)
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
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: Colors.red,
                      borderColor: Colors.red,
                      spacing: 0.0)
                  : Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: LinearPercentIndicator(
                        width: 120.0,
                        lineHeight: 12.0,
                        percent: snackItemData / 5,
                        progressColor: Colors.red,
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

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = RadialGradient(
      center: const Alignment(0.7, -0.6),
      radius: 0.2,
      colors: [const Color(0xFFFFFF00), const Color(0xFF0099FF)],
      stops: [0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return [
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
