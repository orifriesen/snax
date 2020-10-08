import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snax/main.dart';

FirebaseApp fbApp;
FirebaseAuth fbAuth;

Future<void> initializeFirebase() async {
  //Initialize services
  fbApp = await Firebase.initializeApp();
  fbAuth = FirebaseAuth.instance;
  //Add listeners
  fbAuth.authStateChanges().listen((User user) { 
    if (user == null) {
      print('User is currently signed out!');
      
    } else {
      print('User is signed in!');
    }
  });
  navigatorKey.currentState.pushNamed("/login");
}

