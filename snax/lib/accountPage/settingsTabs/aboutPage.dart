import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:snax/accountPage/accountPage.dart';
import 'package:snax/helpers.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          //* Top Container
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              // gradient: SnaxGradients.redBigThings,
              image: DecorationImage(
                image: NetworkImage("https://picsum.photos/400/250"),
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
                      "Snax is a reviewing platform that allows all kinds of people from around the world to review their favorite snacks.",
                    ),
                  ),
                ],
              ),
            ),
          ),
          //* Section 2
          Container(
            padding: EdgeInsets.only(top: 16, right: 32, bottom: 8, left: 32),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Meet The Team",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _teamAccounts(
                      'Team Account',
                      () => customLaunch(
                          "https://www.instagram.com/snaxappofficial/")),
                  _teamAccounts(
                      'Ori',
                      () => customLaunch(
                          "https://www.instagram.com/orifriesen/")),
                  _teamAccounts(
                      'Escher',
                      () =>
                          customLaunch("https://www.instagram.com/escherwd/")),
                  _teamAccounts(
                      'Walt',
                      () => customLaunch(
                          "https://www.instagram.com/waltbringenberg/")),
                  _teamAccounts(
                      'Brandon',
                      () => customLaunch(
                          "https://www.instagram.com/ramirez.brrandon/")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _teamAccounts(String name, customLaunch()) {
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
            Text(
              name,
              style: TextStyle(fontSize: 15),
            ),
            FlatButton(
              onPressed: () {
                customLaunch();
              },
              child: Text("Instagram"),
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
