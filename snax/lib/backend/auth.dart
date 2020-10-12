import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:snax/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

// written by escher



// Google Sign in

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

// Apple Sign In

String _createNonce(int length) {
  final random = Random();
  final charCodes = List<int>.generate(length, (_) {
    int codeUnit;

    switch (random.nextInt(3)) {
      case 0:
        codeUnit = random.nextInt(10) + 48;
        break;
      case 1:
        codeUnit = random.nextInt(26) + 65;
        break;
      case 2:
        codeUnit = random.nextInt(26) + 97;
        break;
    }

    return codeUnit;
  });

  return String.fromCharCodes(charCodes);
}

Future<OAuthCredential> _createAppleOAuthCred() async {
  final nonce = _createNonce(32);
  final nativeAppleCred = Platform.isIOS
      ? await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: sha256.convert(utf8.encode(nonce)).toString(),
        )
      : await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            redirectUri:
                Uri.parse('https://snax-dde4e.firebaseapp.com/__/auth/handler'),
            clientId: 'us.eschr.snax.service',
          ),
          nonce: sha256.convert(utf8.encode(nonce)).toString(),
        );

  return new OAuthCredential(
    providerId: "apple.com", // MUST be "apple.com"
    signInMethod: "oauth", // MUST be "oauth"
    accessToken: nativeAppleCred
        .identityToken, // propagate Apple ID token to BOTH accessToken and idToken parameters
    idToken: nativeAppleCred.identityToken,
    rawNonce: nonce,
  );
}

Future<UserCredential> signInWithApple() async {
  //Generate the credential
  final oauthCred = await _createAppleOAuthCred();
  //Sign in to firebase with it
  return await FirebaseAuth.instance.signInWithCredential(oauthCred);
}
