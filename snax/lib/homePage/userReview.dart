import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class UserReviewPage extends StatefulWidget {
  UserReviewPage(this.snackID);
  String snackID;
  @override
  _UserReviewPageState createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  SnackRating ratings = SnackRating(null, null, null, null, 0, 0, 0, 0);

  IconData _selectedIcon;
  final double minValue = 0.0;
  final double maxValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Review'),
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
                      padding: const EdgeInsets.all(8.0),
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
                        label: Text("Submit Review"),
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
    return RatingBar(
      initialRating: 0,
      minRating: 1,
      tapOnlyMode: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          ratings.overall = rating;
        });
      },
    );
  }

  Widget _snackability() {
    return RatingBar(
      initialRating: 0,
      minRating: 1,
      tapOnlyMode: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          ratings.snackability = rating;
        });
      },
    );
  }

  Widget _mouthfeel() {
    return RatingBar(
      initialRating: 0,
      minRating: 1,
      tapOnlyMode: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          ratings.mouthfeel = rating;
        });
      },
    );
  }

  Widget _accessibility() {
    return RatingBar(
      initialRating: 0,
      minRating: 1,
      tapOnlyMode: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
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
                valueIndicatorColor: Colors.amber,
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
                valueIndicatorColor: Colors.amber,
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
                valueIndicatorColor: Colors.amber,
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
                valueIndicatorColor: Colors.amber,
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
