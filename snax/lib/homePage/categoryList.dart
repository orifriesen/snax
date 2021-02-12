import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/homePage/specificSnack.dart';
import 'package:snax/themes.dart';

import '../helpers.dart';
import 'homePageFunctions.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key, this.item}) : super(key: key);
  final SnackItem item;

  @override
  _CategoryPage createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin<CategoryPage> {
  SnackItem chosenSnack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: getTheme(context).appBarBrightness(),
          elevation: 0,
          title: Text(widget.item.type.name, style: TextStyle(color: getTheme(context).appBarContrastForText())),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                color: getTheme(context).appBarContrastForText(),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: BarcodeAddSearch(
                          (SnackSearchResultItem returnSnack) async {
                        chosenSnack =
                            await SnaxBackend.getSnack(returnSnack.id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductPage(item: widget.item)));
                      }, showCards: false, showUsers: true));
                }),
            IconButton(
                icon: const Icon(Icons.more_vert),
                color: getTheme(context).appBarContrastForText(),
                onPressed: () {})
          ],
        ),
        body: Stack(children: [
          Container(
              child: SafeArea(
                  left: false,
                  right: false,
                  bottom: false,
                  child: Container(height: 80)),
              decoration: BoxDecoration(
                  color: SnaxColors.redAccent,
                  gradient: getTheme(context).bigGradient(),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)))),
          SafeArea(
              left: false,
              right: false,
              bottom: false,
              child: CategoryList(item: widget.item))
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryList extends StatefulWidget {
  CategoryList({Key key, this.item}) : super(key: key);
  final SnackItem item;

  @override
  _CategoryList createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList>
    with AutomaticKeepAliveClientMixin<CategoryList> {
  List<SnackItem> categorySnacks;

  @override
  void initState() {
    print("getting charts");
    SnaxBackend.getSnacksInCategory(widget.item.type.id, SnackListSort.trending)
        .then((results) {
      setState(() {
        categorySnacks = results;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getList(context, categorySnacks);
  }

  @override
  bool get wantKeepAlive => true;
}
