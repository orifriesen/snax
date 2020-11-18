import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/requests.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settingsTabs/aboutPage.dart';
import 'settingsTabs/helpPage.dart';

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
      backgroundColor: !isDark(context)
          ? SnaxColors.redAccent
          : Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: SnaxColors.redAccent,
        title: Text('Settings'),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlatButton(
              onPressed: () async {
                try {
                await SnaxBackend.auth.logOut(context: context);
                Navigator.of(context).pop();
                } catch (error) {
                  print(error);
                  Fluttertoast.showToast(msg: "Failed to Log Out!");
                }
              },
              child: Row(
                children: [
                  Icon(Icons.logout,color: Colors.white,),
                  Text(
                    " Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpPage()),
        ),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
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
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
          )
        ],
      ),
    );
  }

  FlatButton reportButton(String title, IconData iconData) {
    return FlatButton(
      onPressed: () => {
        customLaunch(
            "mailto:thesnaxofficial@gmail.com?subject=Reporting%20a%20Problem&body=")
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
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
