import 'package:flutter/material.dart';

class BarcodeAddCodePage extends StatefulWidget {

  int upc;

  BarcodeAddCodePage(upc);

  @override
  _BarcodeAddCodePageState createState() => _BarcodeAddCodePageState();
}

class _BarcodeAddCodePageState extends State<BarcodeAddCodePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red
    );
  }
}