import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snax/backend/auth.dart';
import 'package:snax/backend/backend.dart';

/*
  Login Page

  Note: 
  Sign in with Apple is disabled on Android due to complications with the callback. 
  Google Login works on both platforms.
*/

class LoginPageArguments {
  final Function handler;

  LoginPageArguments(this.handler);
}

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    //Get the args, which includes the handler function
    final LoginPageArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Container(
            child: Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                        color: Colors.black87,
                        height: double.infinity,
                        width: double.infinity,
                        child: Opacity(
                            opacity: 0.25,
                            child: Image.asset("assets/login-splash-alt.jpg",
                                fit: BoxFit.cover))),
                    Container(
                        child: Image.asset("assets/snax-temp-logo.png"),
                        height: 82),
                  ],
                  alignment: Alignment.center,
                )),
                Container(
                    height: Platform.isIOS ? 200 : 145,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, Platform.isIOS ? 130 : 65, 16, 32),
                      child: Text(
                        "An account is required to post reviews and make comments on the feed",
                        textAlign: TextAlign.center,
                      ),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SignInButton(
                        iconName: "icon-google.png",
                        buttonColor: Colors.red,
                        title: "Log In with Google",
                        press: () async {
                          try {
                            await signInWithGoogle();
                            Navigator.of(context).pop();
                          } catch (error) {
                            print("Failed to login (google)");
                            print(error);
                          }
                        }),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                    ),
                    if (Platform.isIOS)
                      SignInButton(
                          iconName: "icon-apple.png",
                          buttonColor: Colors.black87,
                          title: "Log In with Apple",
                          press: () async {
                            try {
                              await signInWithApple();
                              Navigator.of(context).pop();
                            } catch (error) {
                              print("Failed to login (apple)");
                              print(error);
                            }
                          }),
                  ]),
            )
          ],
          alignment: Alignment.bottomCenter,
        )));
  }
}

class SignInButton extends StatelessWidget {
  final String iconName;
  final Color buttonColor;
  final String title;
  final Function press;

  const SignInButton({this.iconName, this.buttonColor, this.title, this.press});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: this.press,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/" + this.iconName,
                scale: 4.0,
              ),
              Padding(padding: EdgeInsets.only(left: 16)),
              Text(this.title,
                  style: TextStyle(fontSize: 17, color: Colors.white))
            ],
          ),
        ),
        color: this.buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)));
  }
}
