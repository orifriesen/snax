import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';
import 'package:snax/themes.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  PickedFile _imageFile;
  ImagePicker _imagePicker = ImagePicker();

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final usernameController = TextEditingController();
  final webController = TextEditingController();

  bool uploadingImage = false;
  bool error = false;

  //* Select an image via gallery or camera
  _pickImage(ImageSource source) async {
    // Navigator.of(context).pop();
    setState(() {
      this.uploadingImage = true;
    });
    try {
      final pickedFile = await _imagePicker.getImage(source: source);
      await SnaxBackend.updateProfilePhoto(pickedFile);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (error) {
      print(error);
      print("Failed to upload profile photo");
    }
    setState(() {
      this.uploadingImage = false;
    });
  }

  //* Crop an image
  // Future _cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //     sourcePath: _imageFile.path,
  //     cropStyle: CropStyle.circle,
  //     maxWidth: 400,
  //     maxHeight: 400,
  //   );
  //   setState(() {
  //     _imageFile = cropped ?? _imageFile;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    nameController.text = SnaxBackend.currentUser.name;
    usernameController.text = SnaxBackend.currentUser.username;
    bioController.text = SnaxBackend.currentUser.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getTheme(context).gradientStart,
        leadingWidth: 90,
        brightness: getTheme(context).appBarBrightness(),
        leading: FlatButton(
            child: Text(
              'Cancel',
              style:
                  TextStyle(color: getTheme(context).appBarContrastForText()),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            shape: CircleBorder(side: BorderSide(color: Colors.transparent))),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: getTheme(context).appBarContrastForText()),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              SnaxBackend.updateProfile(
                  name: nameController.text,
                  username: usernameController.text,
                  bio: bioController.text.trim());
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style:
                  TextStyle(color: getTheme(context).appBarContrastForText()),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              // end: Alignment.center,
              end: Alignment.centerRight,
              colors: [
                getTheme(context).gradientStart,
                getTheme(context).gradientEnd
              ],
            ),
          ),
          child: Column(
            children: [
              _profileImage(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: InkWell(
                    child: Text(
                      'Change Profile Photo',
                      style: TextStyle(
                        fontSize: 15,
                        color: getTheme(context).appBarContrastForText(),
                      ),
                    ),
                    onTap: () => {
                      showModalBottomSheet(
                        context: context,
                        builder: (builder) => _imageSheet(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29),
                        ),
                      )
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(32, 0, 0, 0), blurRadius: 12)
                    ],
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 400,
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _nameTextField(),
                                _usernameTextField(),
                                _bioTextField(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            Hero(
              tag: 'profile-photo',
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 80.0,
                child: this.uploadingImage
                    ? Container(
                        child: Center(child: CircularProgressIndicator()),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black54),
                      )
                    : null,
                backgroundImage: _imageFile == null
                    ? (SnaxBackend.currentUser.photo != null)
                        ? NetworkImage(SnaxBackend.currentUser.photo)
                        : AssetImage("assets/blank_user.png")
                    : FileImage(
                        File(_imageFile.path),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSheet() {
    return Container(
      // height: 100,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change Profile Photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () => {_pickImage(ImageSource.camera)},
                label: Text('Camera'),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image_outlined),
                onPressed: () => {_pickImage(ImageSource.gallery)},
                // {_pickImage(ImageSource.gallery)},
                label: Text('Gallery'),
              )
            ],
          ),
          // SizedBox(height: 20),
          // CircleAvatar(
          //   radius: 80,
          //   backgroundImage: _imageFile == null
          //       ? AssetImage("assets/blank_user.png")
          //       : Image.file(_imageFile as File),
          // ),
          // SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     FlatButton(
          //       child: Icon(Icons.crop),
          //       onPressed: () => {_cropImage},
          //     ),
          //     FlatButton(
          //       child: Icon(Icons.check),
          //       onPressed: () => {Navigator.pop(context)},
          //     ),
          //   ],
          // )
        ],
      ),
    );
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
        autocorrect: false,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'([a-z])|([A-Z])|([0-9])|\_|\.|\s')),
        ],
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

  Widget _usernameTextField() {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        autocorrect: false,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'([a-z])|([A-Z])|([0-9])|\_|\.')),
        ],
        controller: usernameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          counterStyle: TextStyle(color: Colors.transparent, fontSize: 0),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          hintText: 'Username',
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
    return Container(
      height: 100,
      child: TextFormField(
        autocorrect: false,
        inputFormatters: [
          LengthLimitingTextInputFormatter(150),
        ],
        controller: bioController,
        minLines: 1,
        maxLines: 8,
        maxLength: 150,
        scrollPhysics: ClampingScrollPhysics(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.only(top: 16, left: 16),
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
