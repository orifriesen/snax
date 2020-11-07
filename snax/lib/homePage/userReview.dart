import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class UserReviewPage extends StatefulWidget {
  UserReviewPage(this.snackID, this.item);
  String snackID;
  String item;
  @override
  _UserReviewPageState createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  SnackRating ratings = SnackRating(null, null, null, null, 0, 0, 0, 0);

  final double minValue = 0.0;
  final double maxValue = 5.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Review'),
          bottom: PreferredSize(
            preferredSize: null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${this.widget.item}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              //* Overall Score
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Overall Score',
                    style: TextStyle(fontSize: 25),
                  ),
                  Tooltip(
                    message: "Rate the overall score of the item",
                    child: IconButton(
                      icon: Icon(Icons.info_outline),
                      iconSize: 20.0,
                      disabledColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _overallScore(),
                ],
              ),

              //* Snackability
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Snackability',
                    style: TextStyle(fontSize: 25),
                  ),
                  Tooltip(
                    message: "Rate how snackable this item is",
                    child: IconButton(
                      icon: Icon(Icons.info_outline),
                      iconSize: 20.0,
                      disabledColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _snackability(),
                ],
              ),

              //* Mouthfeel
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mouth Feel',
                    style: TextStyle(fontSize: 25),
                  ),
                  Tooltip(
                    message: "Rate  the feeling of this item",
                    child: IconButton(
                      icon: Icon(Icons.info_outline),
                      iconSize: 20.0,
                      disabledColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _mouthfeel(),
                ],
              ),

              //* Accessibility
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Accessibility',
                    style: TextStyle(fontSize: 25),
                  ),
                  Tooltip(
                    message: "Rate how accessible this item is",
                    child: IconButton(
                      icon: Icon(Icons.info_outline),
                      iconSize: 20.0,
                      disabledColor: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _accessibility(),
                ],
              ),

              //* Sweetness
              Container(
                child: _sweetness(),
              ),

              //* Saltiness
              Container(
                child: _saltiness(),
              ),

              //* Sourness
              Container(
                child: _sourness(),
              ),

              //* Spiciness
              Container(
                child: _spiciness(),
              ),

              //* Submit Button
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: FloatingActionButton.extended(
                        elevation: 2,
                        onPressed: () {
                          if (ratings.overall != null &&
                              ratings.snackability != null &&
                              ratings.mouthfeel != null &&
                              ratings.accessibility != null) {
                            SnaxBackend.postReview(this.widget.snackID, ratings)
                                .catchError((error) => {});
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                backgroundColor: Colors.red[300],
                                msg: "Please rate this snack to submit!");
                          }
                        },
                        label: Container(
                            width: size.width * .7,
                            alignment: Alignment.center,
                            child: Text("Submit Review")),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _overallScore() {
    return SmoothStarRating(
      rating: 0,
      size: 35,
      filledIconData: Icons.star,
      allowHalfRating: false,
      defaultIconData: Icons.star_border,
      spacing: 8.0,
      onRated: (rating) {
        setState(() {
          ratings.overall = rating;
        });
      },
    );
  }

  Widget _snackability() {
    return SmoothStarRating(
      rating: 0,
      size: 35,
      filledIconData: Icons.star,
      allowHalfRating: false,
      defaultIconData: Icons.star_border,
      spacing: 8.0,
      onRated: (rating) {
        setState(() {
          ratings.snackability = rating;
        });
      },
    );
  }

  Widget _mouthfeel() {
    return SmoothStarRating(
      rating: 0,
      size: 35,
      filledIconData: Icons.star,
      allowHalfRating: false,
      defaultIconData: Icons.star_border,
      spacing: 8.0,
      onRated: (rating) {
        setState(() {
          ratings.mouthfeel = rating;
        });
      },
    );
  }

  Widget _accessibility() {
    return SmoothStarRating(
      rating: 0,
      size: 35,
      filledIconData: Icons.star,
      allowHalfRating: false,
      defaultIconData: Icons.star_border,
      spacing: 8.0,
      onRated: (rating) {
        setState(() {
          ratings.accessibility = rating;
        });
      },
    );
  }

  Widget _sweetness() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sweetness',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.white,
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
              ),
              child: Slider(
                  label: ratings.sweetness.floor().toString(),
                  min: minValue,
                  max: maxValue,
                  value: ratings.sweetness,
                  onChanged: (val) {
                    setState(() => ratings.sweetness = val);
                  })),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 26, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Savory'),
                Text('Sweet'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _saltiness() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saltiness',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.white,
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
              ),
              child: Slider(
                  label: ratings.saltiness.floor().toString(),
                  min: minValue,
                  max: maxValue,
                  value: ratings.saltiness,
                  onChanged: (val) {
                    setState(() => ratings.saltiness = val);
                  })),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 26, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Not Salty'),
                Text('Very Salty'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourness() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sourness',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.white,
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
              ),
              child: Slider(
                  label: ratings.sourness.floor().toString(),
                  min: minValue,
                  max: maxValue,
                  value: ratings.sourness,
                  onChanged: (val) {
                    setState(() => ratings.sourness = val);
                  })),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 26, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Not Sour'),
                Text('Very Sour'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _spiciness() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Spiciness',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.white,
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
              ),
              child: Slider(
                  label: ratings.spicyness.floor().toString(),
                  min: minValue,
                  max: maxValue,
                  value: ratings.spicyness,
                  onChanged: (val) {
                    setState(() => ratings.spicyness = val);
                  })),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 26, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Not Spicy'),
                Text('Very Spicy'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
