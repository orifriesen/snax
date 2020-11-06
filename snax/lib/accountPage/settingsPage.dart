import 'package:flutter/material.dart';

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
      backgroundColor: SnaxColors.settingsBackground,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: SnaxColors.settingsBackground,
        title: Text('Settings'),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlatButton(
              onPressed: () => {},
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.white, fontSize: 18),
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
}
