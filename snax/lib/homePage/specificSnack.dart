import 'package:flutter/material.dart';
import 'package:snax/homePage/snackList.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.item}) : super(key: key);
  final TrendingSnackList item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.item.name),
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(this.item.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ])))
                  ],
                ))));
  }
}
