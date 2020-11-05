import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:snax/accountPage/accountPage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  PickedFile _imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => {Navigator.pop(context)},
            shape: CircleBorder(side: BorderSide(color: Colors.transparent))),
        title: Text('Edit Profile'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            _profileImage(),
            Center(
              child: InkWell(
                child: Text(
                  'Change Profile Photo',
                ),
                onTap: () => {
                  showModalBottomSheet(
                      context: context, builder: (builder) => _imageSheet())
                },
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            _nameTextField(),
            Divider(
              color: Colors.black,
            ),
            _bioTextField(),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  //* This allows the user to change their profile image
  Widget _profileImage() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 80.0,
              backgroundImage: _imageFile == null
                  ? NetworkImage('https://picsum.photos/200/300?grayscale')
                  : FileImage(File(_imageFile.path)),
            ),
          ],
        ),
      ),
    );
  }

  //* This is the pop up sheet that appears when the user requests to change
  //* their profile image
  Widget _imageSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'Change Profile Photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () => {takePhoto(ImageSource.camera)},
                label: Text('Camera'),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image_outlined),
                onPressed: () => {takePhoto(ImageSource.gallery)},
                label: Text('Gallery'),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  //* This allows the user to change their name
  Widget _nameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Name',
              style: TextStyle(fontSize: 15),
            ),
          ),
          border: InputBorder.none,
          hintText: 'Enter your name',
        ),
      ),
    );
  }

  //* This allows the user to change their bio
  Widget _bioTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 150,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.transparent, fontSize: 0),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Bio',
              style: TextStyle(fontSize: 15),
            ),
          ),
          border: InputBorder.none,
          hintText: 'Bio',
        ),
      ),
    );
  }
}
