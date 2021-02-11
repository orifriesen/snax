import 'package:flutter/material.dart';

import 'package:snax/customIcons/instagram_icons.dart';
import 'package:snax/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: getTheme(context).appBarBrightness(),
        title: Text("About"),
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
                    child: Text(
                      "Our goal is to bring everyone together to discuss all types of snack. No matter who you are, we believe that you should be able to express your feelings about your favorite foods.",
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
                        () => customLaunch(
                            "https://www.instagram.com/snaxappofficial/")),
                    teamSocials(
                        context,
                        'Ori',
                        () => customLaunch(
                            "https://www.instagram.com/orifriesen/")),
                    teamSocials(
                        context,
                        'Escher',
                        () => customLaunch(
                            "https://www.instagram.com/escherwd/")),
                    teamSocials(
                        context,
                        'Walt',
                        () => customLaunch(
                            "https://www.instagram.com/waltbringenberg/")),
                    teamSocials(
                        context,
                        'Brandon',
                        () => customLaunch(
                            "https://www.instagram.com/ramirez.brrandon/")),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget teamSocials(BuildContext context, String name, customLaunch()) {
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
                style: TextStyle(fontSize: 15),
              ),
            ),
            //* Instagram
            FlatButton(
              onPressed: () {
                customLaunch();
              },
              child: Icon(
                Instagram.icons8_instagram,
                size: 30,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              minWidth: 5,
            ),
          ],
        ),
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
