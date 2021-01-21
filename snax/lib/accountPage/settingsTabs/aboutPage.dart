import 'package:flutter/material.dart';
import 'package:snax/customIcons/instagram_icons.dart';
import 'package:snax/web_view_container.dart';

class Links {
  String link;
  String name;

  Links({this.link, this.name});
}

class AboutPage extends StatelessWidget {
  List<Links> _links = [
    Links(link: 'https://www.instagram.com/escherwd/', name: 'Escher'),
    Links(link: 'https://www.instagram.com/orifriesen/', name: 'Ori'),
    Links(link: 'https://www.instagram.com/waltbringenberg/', name: 'Walt'),
    Links(link: 'https://www.instagram.com/ramirez.brrandon/', name: 'Brandon')
  ];

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
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              // gradient: SnaxGradients.redBigThings,
              image: DecorationImage(
                image: AssetImage("assets/Artboard.jpeg") != null
                    ? AssetImage("assets/Artboard.jpeg")
                    : NetworkImage("https://picsum.photos/400/250"),
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
                  children: _links
                      .map(
                          (link) => _teamSocials(context, link.name, link.link))
                      .toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _teamSocials(BuildContext context, String name, String url) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewContainer(url)));
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
}
