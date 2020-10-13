import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: Container(
          child: MaterialButton(
        child: Text("click to review pizza pringles"),
        onPressed: () {
          SnaxBackend.postReview("pringles-pizza",
                  SnackRating(5.0, 4.0, 4.0, 5.0, 4.0, 0.0, 0.0, 1.0))
              .then((d) {
            print("sent review");
          });
        },
      )),
    );
  }
}
