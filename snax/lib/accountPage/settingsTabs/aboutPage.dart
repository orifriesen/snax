import 'package:flutter/material.dart';

import 'package:snax/customIcons/eschr_icons.dart';
import 'package:snax/customIcons/git_hub_icons.dart';
import 'package:snax/customIcons/instagram_icons.dart';

import 'package:snax/themes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About",
            style: TextStyle(color: getTheme(context).appBarContrastForText())),
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
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          //* Top Container
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Artboard.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //* Section #1
          Container(
            padding: EdgeInsets.only(top: 32, right: 32, bottom: 0, left: 32),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Who We Are",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: isDark(context) ? Colors.white : Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "We are a group of four people who saw a flaw in the snack industry.\nSo we went to the drawing board and began planning a revolutionary app that would satisfy everyone;\nA social snacking platform -- this is ",
                          ),
                          TextSpan(
                            text: "SNAX.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //* Section 2
          Container(
            padding: EdgeInsets.only(top: 16, right: 32, bottom: 8, left: 32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Meet The Team",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    teamSocials(
                      context,
                      'Snax',
                      Instagram.icons8_instagram,
                      null,
                      null,
                      null,
                      null,
                      () => instagramLink(
                          "https://www.instagram.com/snaxappofficial/"),
                    ),
                    teamSocials(
                      context,
                      'Ori',
                      GitHub.github,
                      null,
                      Instagram.icons8_instagram,
                      null,
                      () => instagramLink(
                          "https://www.instagram.com/orifriesen/"),
                      () => githubLink("https://github.com/orifriesen"),
                    ),
                    teamSocials(
                      context,
                      'Escher',
                      GitHub.github,
                      Instagram.icons8_instagram,
                      Eschr.proj_eschrus__1_,
                      () =>
                          instagramLink("https://www.instagram.com/escherwd/"),
                      () => eschrLink("https://eschr.us"),
                      () => githubLink("https://github.com/escherwd"),
                    ),
                    teamSocials(
                      context,
                      'Walt',
                      GitHub.github,
                      null,
                      Instagram.icons8_instagram,
                      null,
                      () => instagramLink(
                          "https://www.instagram.com/waltbringenberg/"),
                      () => githubLink("https://github.com/walterbb"),
                    ),
                    teamSocials(
                      context,
                      'Brandon',
                      GitHub.github,
                      null,
                      Instagram.icons8_instagram,
                      null,
                      () => instagramLink(
                          "https://www.instagram.com/ramirez.brrandon/"),
                      () => githubLink("https://github.com/rBrandon1/"),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget teamSocials(
    BuildContext context,
    String name,
    IconData eschrIcon,
    IconData instaIcon,
    IconData gitIcon,
    instagramLink(),
    githubLink(),
    eschrLink(),
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 8),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(60, 0, 0, 0),
              blurRadius: 8,
            )
          ],
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).canvasColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                //* Instagram
                FlatButton(
                  onPressed: () {
                    instagramLink();
                  },
                  child: Icon(
                    instaIcon,
                    size: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minWidth: 5,
                ),
                //* GitHub
                FlatButton(
                  onPressed: () {
                    githubLink();
                  },
                  child: Icon(
                    gitIcon,
                    size: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minWidth: 5,
                ),
                //* Escher's Website
                FlatButton(
                  onPressed: () {
                    eschrLink();
                  },
                  child: Icon(
                    eschrIcon,
                    size: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minWidth: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  instagramLink(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not work");
    }
  }

  githubLink(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not work");
    }
  }

  eschrLink(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not work");
    }
  }
}
