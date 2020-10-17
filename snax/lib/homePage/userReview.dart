import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:snax/backend/backend.dart';

class UserReviewPage extends StatefulWidget {
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
    return Container(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
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

                // ratings.overall != null
                //     ? Text(
                //         "Rating: ${ratings.overall}",
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       )
                //     : Container(),

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
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () => {},
                        label: Text("Submit"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sweetness',
              style: TextStyle(fontSize: 25),
            ),
            Tooltip(
              showDuration: Duration(seconds: 3),
              message:
                  "Use the slider to rate the sweetness of this item (left is savory, right is sweet)",
              child: IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: 20.0,
                disabledColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ],
        ),
        SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.white,
              valueIndicatorColor: Colors.amber,
              valueIndicatorTextStyle: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
              overlayColor: Colors.transparent,
              trackHeight: 15.0,
            ),
            child: Slider(
                // divisions: 4,
                label: ratings.sweetness.ceil().toString(),
                min: minValue,
                max: maxValue,
                value: ratings.sweetness,
                onChanged: (val) {
                  print(ratings.sweetness);
                  setState(() => ratings.sweetness = val);
                })),
      ],
    );
  }

  Widget _saltiness() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Saltiness',
              style: TextStyle(fontSize: 25),
            ),
            Tooltip(
              showDuration: Duration(seconds: 3),
              message:
                  "Use the slider to rate the saltiness of this item (left is less salty, right is more salty)",
              child: IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: 20.0,
                disabledColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ],
        ),
        SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.white,
              valueIndicatorColor: Colors.amber,
              valueIndicatorTextStyle: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
              overlayColor: Colors.transparent,
              trackHeight: 15.0,
            ),
            child: Slider(
                // divisions: 4,
                label: ratings.saltiness.ceil().toString(),
                min: minValue,
                max: maxValue,
                value: ratings.saltiness,
                onChanged: (val) {
                  print(ratings.saltiness);
                  setState(() => ratings.saltiness = val);
                })),
      ],
    );
  }

  Widget _sourness() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sourness',
              style: TextStyle(fontSize: 25),
            ),
            Tooltip(
              showDuration: Duration(seconds: 3),
              message:
                  "Use the slider to rate the sourness of this item (left is less sour, right is more sour)",
              child: IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: 20.0,
                disabledColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ],
        ),
        SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.white,
              valueIndicatorColor: Colors.amber,
              valueIndicatorTextStyle: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
              overlayColor: Colors.transparent,
              trackHeight: 15.0,
            ),
            child: Slider(
                // divisions: 4,
                label: ratings.sourness.ceil().toString(),
                min: minValue,
                max: maxValue,
                value: ratings.sourness,
                onChanged: (val) {
                  print(ratings.sourness);
                  setState(() => ratings.sourness = val);
                })),
      ],
    );
  }

  Widget _spiciness() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Spiciness',
              style: TextStyle(fontSize: 25),
            ),
            Tooltip(
              showDuration: Duration(seconds: 3),
              message:
                  "Use the slider to rate the spiciness of this item (left is less spicy, right is more spicy)",
              child: IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: 20.0,
                disabledColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ],
        ),
        SliderTheme(
            data: SliderThemeData(
              thumbColor: Colors.white,
              valueIndicatorColor: Colors.amber,
              valueIndicatorTextStyle: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
              overlayColor: Colors.transparent,
              trackHeight: 15.0,
            ),
            child: Slider(
                // divisions: 4,
                label: ratings.spicyness.ceil().toString(),
                min: minValue,
                max: maxValue,
                value: ratings.spicyness,
                onChanged: (val) {
                  print(ratings.spicyness);
                  setState(() => ratings.spicyness = val);
                })),
      ],
    );
  }
}
