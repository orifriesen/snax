import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/requests.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settingsTabs/aboutPage.dart';

import 'package:snax/helpers.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 1,
        title: Text('Settings'),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlatButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => Platform.isIOS
                      ? CupertinoAlertDialog(
                          title: Text("Log Out"),
                          content: Text("Are you sure you want to log out?"),
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
                              onPressed: () async {
                                try {
                                  await SnaxBackend.auth
                                      .logOut(context: context);
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  print(error);
                                  Fluttertoast.showToast(
                                      msg: "Failed to Log Out!");
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )
                      : AlertDialog(
                          title: Text("Log Out"),
                          content: Text("Are you sure you want to log out?"),
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
                              onPressed: () async {
                                try {
                                  await SnaxBackend.auth
                                      .logOut(context: context);
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  print(error);
                                  Fluttertoast.showToast(
                                      msg: "Failed to Log Out!");
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                );
                // try {
                //   await SnaxBackend.auth.logOut(context: context);
                //   Navigator.of(context).pop();
                // } catch (error) {
                //   print(error);
                //   Fluttertoast.showToast(msg: "Failed to Log Out!");
                // }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: SnaxColors.redAccent,
                  ),
                  Text(
                    " Log Out",
                    style: TextStyle(color: SnaxColors.redAccent, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 4, top: 8, right: 4),
        child: Container(
          height: size.height,
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  helpButton("Help", Icons.help_outline_rounded),
                  aboutButton("About", Icons.info_outline_rounded),
                  reportButton(
                      "Report a Problem", Icons.report_problem_outlined),
                  appLibraries("Open Source Libraries", Icons.article_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  FlatButton helpButton(String title, IconData iconData) {
    return FlatButton(
      onPressed: () => {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HelpPage()),
        showCupertinoDialog(
          context: context,
          builder: (_) => Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text("Nothing To See Here"),
                  content: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "This page is currently under construction "),
                        WidgetSpan(
                          child: Icon(Icons.construction),
                        ),
                      ],
                    ),
                  ),
                )
              : AlertDialog(
                  title: Text("Nothing To See Here"),
                  content: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "This page is currently under construction "),
                        WidgetSpan(
                          child: Icon(Icons.construction),
                        ),
                      ],
                    ),
                  ),
                ),
          barrierDismissible: true,
        ),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
              ),
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
            color: SnaxColors.subtext
          )
        ],
      ),
    );
  }

  FlatButton aboutButton(String title, IconData iconData) {
    return FlatButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()),
        ),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
              ),
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

  FlatButton reportButton(String title, IconData iconData) {
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
          Row(
            children: [
              Icon(
                iconData,
              ),
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

  FlatButton appLibraries(String title, IconData iconData) {
    return FlatButton(
      onPressed: () {
        showLicensePage(
          context: context,
          applicationName: "Snax",
          applicationLegalese: "Developed by Snax Co.",
          applicationVersion: "0.0.01",
          applicationIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlutterLogo(size: 50),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
              ),
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

  //* URL Launcher
  //* command can be any link
  customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not work");
    }
  }
}
