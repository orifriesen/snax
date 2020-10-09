import 'package:flutter/material.dart';

class UserReviewPage extends StatelessWidget {
  final int rating;

  const UserReviewPage({Key key, this.rating = 0})
      : assert(rating != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Review'),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(32, 15, 15, 15),
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
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
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
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
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
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
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
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
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
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
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
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ),
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
