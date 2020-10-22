import 'package:flutter/material.dart';
import 'package:snax/homePage/snackList.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/backend/backend.dart';

// class SliderContainer extends StatefulWidget {
//   @override
//   UserReviewPage createState() => UserReviewPage();
// }

class UserReviewPage extends StatelessWidget {
  UserReviewPage({this.item});
  final SnackItem item;

  final double minValue = 1.0;
  final double maxValue = 10.0;
  double count = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Review'),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(32, 10, 20, 20),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //* Review 1
                Row(
                  children: [
                    Text(
                      'Review1',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview1',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(1, (index) {
                      return SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.sweetness,
                          size: 24,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 32.0);
                    }),
                  ),
                ),
                //* Review 2
                Row(
                  children: [
                    Text(
                      'Review2',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview2',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(1, (index) {
                      return SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.sweetness,
                          size: 24,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 32.0);
                    }),
                  ),
                ),
                //* Review 3
                Row(
                  children: [
                    Text(
                      'Review3',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview3',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(1, (index) {
                      return SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.sweetness,
                          size: 24,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 32.0);
                    }),
                  ),
                ),
                //* Review 4
                Row(
                  children: [
                    Text(
                      'Review4',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview4',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(1, (index) {
                      return SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.sweetness,
                          size: 24,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 32.0);
                    }),
                  ),
                ),
                //* Review 5
                Row(
                  children: [
                    Text(
                      'Review5',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview5',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(1, (index) {
                      return SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.sweetness,
                          size: 24,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 32.0);
                    }),
                  ),
                ),
                //* Review 6
                Row(
                  children: [
                    Text(
                      'Review6',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview6',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(1, (index) {
                      return SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: this.item.averageRatings.sweetness,
                          size: 24,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 32.0);
                    }),
                  ),
                ),
                //* Review 7
                Row(
                  children: [
                    Text(
                      'Review7',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview7',
                      style: TextStyle(fontSize: 15),
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
                        label: count.abs().toString(),
                        min: minValue,
                        max: maxValue,
                        value: count,
                        onChanged: (val) {
                          print(val);
                          // setState(() => count = val);
                          count = val;
                        })),
                //* Review 8
                Row(
                  children: [
                    Text(
                      'Review8',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'SubReview8',
                      style: TextStyle(fontSize: 15),
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
                        label: count.abs().toString(),
                        min: minValue,
                        max: maxValue,
                        value: count,
                        onChanged: (val) {
                          print(val);
                          // setState(() => count = val);
                          count = val;
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
