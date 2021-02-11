import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snax/main.dart';
import 'package:snax/themes.dart';

import 'settingsTabs/aboutPage.dart';
import 'package:snax/helpers.dart';
import 'package:snax/backend/requests.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        backgroundColor: getTheme(context).appBarColor,
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
                    color: getTheme(context).accentColor,
                  ),
                  Text(
                    " Log Out",
                    style: TextStyle(
                        color: getTheme(context).accentColor, fontSize: 18),
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
                  // helpButton("Help", Icons.help_outline_rounded),
                  reportButton(
                      "Report a Problem", Icons.warning_amber_outlined),
                  aboutButton("About", Icons.info_outline_rounded),
                  appLibraries("Open Source Libraries", Icons.article_outlined),
                  themeSettingsButton(
                      "Dark Theme", Icons.nightlight_round, context, true),
                  themeSettingsButton(
                      "Light Theme", Icons.brightness_5_rounded, context, false)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FlatButton helpButton(String title, IconData iconData) {
  //   return FlatButton(
  //     onPressed: () => {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HelpPage()),
  //       ),
  //       showCupertinoDialog(
  //         context: context,
  //         builder: (_) => Platform.isIOS
  //             ? CupertinoAlertDialog(
  //                 title: Text("Nothing To See Here"),
  //                 content: RichText(
  //                   textAlign: TextAlign.center,
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                           text: "This page is currently under construction "),
  //                       WidgetSpan(
  //                         child: Icon(Icons.construction),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               )
  //             : AlertDialog(
  //                 title: Text("Nothing To See Here"),
  //                 content: RichText(
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                           text: "This page is currently under construction "),
  //                       WidgetSpan(
  //                         child: Icon(Icons.construction),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //         barrierDismissible: true,
  //       ),
  //     },
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               iconData,
  //             ),
  //             SizedBox(width: 8),
  //             Text(
  //               title,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Icon(Icons.arrow_forward_ios, color: SnaxColors.subtext)
  //       ],
  //     ),
  //   );
  // }

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

  FlatButton themeSettingsButton(
      String title, IconData iconData, BuildContext context, bool dark) {
    return FlatButton(
      onPressed: () {
        showModalBottomSheet<Void>(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          builder: (BuildContext context) {
            if (dark)
              return themeSettings(darkThemeList, currentDarkTheme.name, true);
            else
              return themeSettings(
                  lightThemeList, currentLightTheme.name, false);
          },
        ).then((_) {
          setState(() {});
          themeUpdate.add(_);
        });
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
          Row(
            children: [
              Text(
                dark ? currentDarkTheme.name : currentLightTheme.name,
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: SnaxColors.subtext,
              ),
            ],
          )
        ],
      ),
    );
  }

  Container themeSettings(
      List<SnaxTheme> themes, String currentTheme, bool dark) {
    return Container(
        padding: EdgeInsets.only(top: 4),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: themes.length,
            itemBuilder: (BuildContext context, int index) {
              bool current =
                  (themes[index].name == currentTheme) ? true : false;
              return themeButton(themes[index], current, dark);
            }));
  }

  FlatButton themeButton(SnaxTheme theme, bool current, bool dark) {
    return FlatButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (dark) {
          currentDarkTheme = theme;
          await prefs.setString("dark-theme", theme.id);
        } else {
          currentLightTheme = theme;
          await prefs.setString("light-theme", theme.id);
        }

        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            current ? Icons.check_circle_rounded : Icons.brightness_1_outlined,
            color:
                current ? getTheme(context).primaryColor : SnaxColors.subtext,
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
          ),
          Text(theme.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: current ? FontWeight.normal : FontWeight.w300,
              ))
        ],
      ),
    );
  }

  //* URL Launcher
  customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not work");
    }
  }
}
