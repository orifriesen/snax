import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:snax/accountPage/accountPage.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  PickedFile _imageFile;
  ImagePicker _imagePicker = ImagePicker();

  final nameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = SnaxBackend.currentUser.name;
    bioController.text = SnaxBackend.currentUser.bio;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: SnaxColors.gradientStart,
        leadingWidth: 90,
        leading: FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            shape: CircleBorder(side: BorderSide(color: Colors.transparent))),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              SnaxBackend.currentUser.name = nameController.text;
              SnaxBackend.currentUser.bio = bioController.text.trim();
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(gradient: SnaxGradients.redBigThings),
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          children: [
            _profileImage(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: InkWell(
                  child: Text(
                    'Change Profile Photo',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  onTap: () => {
                    showModalBottomSheet(
                        context: context, builder: (builder) => _imageSheet())
                  },
                ),
              ),
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(color: Color.fromARGB(32, 0, 0, 0), blurRadius: 12)
                ],
                color: Theme.of(context).canvasColor,
              ),
              child: Column(children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 16, bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _nameTextField(),
                      _bioTextField(),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  //* This allows the user to change their profile image
  Widget _profileImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
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

  takePhoto(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  //* This allows the user to change their name
  Widget _nameTextField() {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          counterStyle: TextStyle(color: Colors.transparent, fontSize: 0),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          hintText: 'Name',
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: SnaxColors.subtext,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //* This allows the user to change their bio
  Widget _bioTextField() {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: bioController,
        minLines: 1,
        maxLines: 5,
        maxLength: 150,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          counterStyle: TextStyle(color: Colors.transparent, fontSize: 0),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          hintText: 'Bio',
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: SnaxColors.subtext,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
