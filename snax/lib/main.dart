import 'package:flutter/material.dart';
import 'package:snax/tabs.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.redAccent[100]
        ),
        home: AppTabs());
  }
}

void main() {
  runApp(MyApp());
}
