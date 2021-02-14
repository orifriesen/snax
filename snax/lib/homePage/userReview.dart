import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/customIcons/mouth_feel_icons.dart';
import 'package:snax/customIcons/my_flutter_app_icons.dart';
import 'package:snax/customIcons/sourness_icons.dart';
import 'package:snax/customIcons/spiciness_icons.dart';
import 'package:snax/helpers.dart';

import '../themes.dart';

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
          leading: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_rounded)),
          elevation: 0,
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          brightness: isDark(context) ? Brightness.dark : Brightness.light,
          title: Text(
            'Review Snack',
            style: TextStyle(
                color: !isDark(context) ? Colors.black : Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              //* Overall Score
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    Icons.analytics_outlined,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Overall Score",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Generally, how much do you like this snack?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _overallScore(),
                              ratings.overall != null
                                  ? Text(
                                      "${this.ratings.overall.floor()}/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    )
                                  : Text(
                                      "0/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //* Snackability
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    Icons.fastfood_outlined,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Snackability",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Could you see yourself snacking on these for hours?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _snackability(),
                              ratings.snackability != null
                                  ? Text(
                                      "${this.ratings.snackability.floor()}/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    )
                                  : Text(
                                      "0/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //* Mouthfeel
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    MouthFeel.noun_smiling_mouth_1172516,
                                    size: 45,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mouth Feel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Does this snack create an enjoyable eating experience?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _mouthfeel(),
                              ratings.mouthfeel != null
                                  ? Text(
                                      "${this.ratings.mouthfeel.floor()}/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    )
                                  : Text(
                                      "0/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //* Accessibility
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    Icons.shopping_basket_outlined,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Accessibility",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Is this a product that you can purchase easily?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _accessibility(),
                              ratings.accessibility != null
                                  ? Text(
                                      "${this.ratings.accessibility.floor()}/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    )
                                  : Text(
                                      "0/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: SnaxColors.subtext),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //* Sweetness
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(Icons.cake_outlined, size: 30),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sweetness",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        "Would you say that this snack is sweet?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          child: _sweetness(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //* Saltiness
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    MyFlutterApp.noun_salt_3670709,
                                    size: 60,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Saltiness",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "How much salt is this snack filled with?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          child: _saltiness(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //* Sourness
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    Sourness.noun_lemons_1437833,
                                    size: 45,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sourness",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Is this snack sour to the point that you spit it out?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          child: _sourness(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //* Spiciness
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16.0, left: 8, right: 8),
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(36, 0, 0, 0), blurRadius: 6),
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
                    color:
                        isDark(context) ? null : Theme.of(context).canvasColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    Spiciness.noun_spicy_3017538,
                                    size: 45,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Spiciness",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Does this snack burn your mouth when you eat it?",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          child: _spiciness(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //* Submit Button
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
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
                              timeInSecForIosWeb: 2,
                              backgroundColor: SnaxColors.darkGreyGradientStart,
                              msg: "Please rate each category",
                            );
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
    return RatingBar(
      initialRating: 0,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: getTheme(context).accentColor,
        ),
        empty: Icon(
          Icons.star_outline,
          color: getTheme(context).accentColor,
        ),
        half: null,
      ),
      itemSize: 35,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: getTheme(context).accentColor,
        ),
        empty: Icon(
          Icons.star_outline,
          color: getTheme(context).accentColor,
        ),
        half: null,
      ),
      itemSize: 35,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: getTheme(context).accentColor,
        ),
        empty: Icon(
          Icons.star_outline,
          color: getTheme(context).accentColor,
        ),
        half: null,
      ),
      itemSize: 35,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
          color: getTheme(context).accentColor,
        ),
        empty: Icon(
          Icons.star_outline,
          color: getTheme(context).accentColor,
        ),
        half: null,
      ),
      itemSize: 35,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
        SliderTheme(
            data: SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
              valueIndicatorTextStyle: TextStyle(
                fontSize: 10.0,
                color: !isDark(context) ? Colors.white : Colors.black,
              ),
              overlayColor: Colors.transparent,
              trackHeight: 10.0,
              thumbColor: Colors.white,
              activeTrackColor: getTheme(context).accentColor,
              inactiveTrackColor: Colors.grey[350],
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
    );
  }

  Widget _saltiness() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: !isDark(context) ? Colors.white : Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
                thumbColor: Colors.white,
                activeTrackColor: getTheme(context).accentColor,
                inactiveTrackColor: Colors.grey[350],
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
          SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: !isDark(context) ? Colors.white : Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
                thumbColor: Colors.white,
                activeTrackColor: getTheme(context).accentColor,
                inactiveTrackColor: Colors.grey[350],
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
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 10.0,
                  color: !isDark(context) ? Colors.white : Colors.black,
                ),
                overlayColor: Colors.transparent,
                trackHeight: 10.0,
                thumbColor: Colors.white,
                activeTrackColor: getTheme(context).accentColor,
                inactiveTrackColor: Colors.grey[350],
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
