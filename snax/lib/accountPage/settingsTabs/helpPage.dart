import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: reportButton("Report a Problem"),
    );
  }

  FlatButton reportButton(String title) {
    return FlatButton(
      onPressed: () => {
        showCupertinoDialog(
          context: context,
          builder: (_) => Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text("Open Mail Application"),
                  content: Text("Do you want to open your mail application?"),
                  actions: [
                    FlatButton(
                        child: Text(
                          "No",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () => {Navigator.pop(context)}),
                    FlatButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () => {
                        customLaunch(
                            "mailto:thesnaxofficial@gmail.com?subject=Reporting%20a%20Problem&body="),
                        Navigator.pop(context),
                      },
                    )
                  ],
                )
              : AlertDialog(
                  title: Text("Open Mail Application"),
                  content: Text("Do you want to open your mail application?"),
                  actions: [
                    FlatButton(
                        child: Text(
                          "No",
                          style: TextStyle(
                              fontSize: 18,
                              color: !isDark(context)
                                  ? Colors.black
                                  : Colors.white),
                        ),
                        onPressed: () => {Navigator.pop(context)}),
                    FlatButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 18,
                          color: !isDark(context) ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: () => {
                        customLaunch(
                            "mailto:thesnaxofficial@gmail.com?subject=Reporting%20a%20Problem&body="),
                        Navigator.pop(context),
                      },
                    )
                  ],
                ),
          barrierDismissible: true,
        ),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: SnaxColors.subtext,
          )
        ],
      ),
    );
  }

  customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not work");
    }
  }
}
