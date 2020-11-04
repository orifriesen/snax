import 'package:flutter/material.dart';
import 'package:snax/accountPage/accountPage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      //TODO Create rows of TextFields with user changes for Pic, Username, Handle, and Bio
    );
  }
}
