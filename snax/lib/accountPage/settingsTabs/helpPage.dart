import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers.dart';
import '../../themes.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
          style: TextStyle(
            color: getTheme(context).appBarContrastForText(),
          ),
        ),
        leading: FlatButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: getTheme(context).appBarContrastForText(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        brightness: getTheme(context).appBarBrightness(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 4, top: 8, right: 4),
        child: ListView(
          shrinkWrap: true,
          children: [
            reportButton(context, "Report a Problem", Icons.report_outlined),
            verificationForm(
              context,
              "Request Verification",
              Icons.check_outlined,
            ),
          ],
        ),
      ),
    );
  }

  FlatButton reportButton(
      BuildContext context, String title, IconData iconData) {
    return FlatButton(
      onPressed: () => {
        showCupertinoDialog(
          context: context,
          builder: (_) => Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text("Report a Problem"),
                  content: Text(
                    "Do you want to open your mail application to report?",
                  ),
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
                          "mailto:thesnaxofficial@gmail.com?subject=Reporting%20a%20Problem&body=",
                        ),
                        Navigator.pop(context),
                      },
                    )
                  ],
                )
              : AlertDialog(
                  title: Text("Report a Problem"),
                  content: Text(
                    "Do you want to open your mail application to report?",
                  ),
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
                          "mailto:thesnaxofficial@gmail.com?subject=Reporting%20a%20Problem&body=",
                        ),
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
          Row(
            children: [
              Icon(iconData),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: SnaxColors.subtext,
          )
        ],
      ),
    );
  }

  FlatButton verificationForm(
      BuildContext context, String title, IconData iconData) {
    return FlatButton(
      onPressed: () => {
        customLaunch("https://forms.gle/f6tSPuRzgxU545fH7"),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(iconData),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
      print("Command could not work");
    }
  }
}
