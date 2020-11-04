import 'package:flutter/material.dart';
import 'package:snax/accountPage/sizeConfig.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Color burningOrangeStart = const Color.fromRGBO(255, 65, 108, 1.0);
  Color burningOrangeEnd = const Color.fromRGBO(255, 75, 43, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => {},
          )
        ],
      ),
      body: ListView(
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [burningOrangeEnd, burningOrangeStart],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    child: Column(
                      children: [
                        _profileInfo(),
                        SizedBox(
                          height: 10,
                        ),
                        _profileBio(),
                        SizedBox(
                          height: 10,
                        ),
                        _profileStats(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//* This is the users profile picture, username, and handle
Widget _profileInfo() {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1584530085056-979bab3cc8f6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80')),
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Username',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Your Handle',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ],
  );
}

Widget _profileBio() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This is where the user bio will be placed. It will strictly have a character count of 150 or 160 depending on what you guys want. The style may vary. ',
            style: TextStyle(color: Colors.white, fontSize: 15),
          )
        ],
      ),
    ),
  );
}

//* This is for the following, followers, and EP
Widget _profileStats() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              '2k',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Following',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '100k',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Followers',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          child: RaisedButton(
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            onPressed: () => {},
            child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}
