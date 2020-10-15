import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {


  @override
  void initState() {
    // TODO: implement initState
    print("getting charts");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Account"),
        ),
        body: Container(
          child: Text("account page"),
        ));
  }
}
