import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/homePage/specificSnack.dart';

import '../helpers.dart';
import 'homePageFunctions.dart';

class CategoryPage extends StatefulWidget {
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
          brightness: Brightness.dark,
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
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
                                    ProductPage(item: chosenSnack)));
                      }, showCards: false, showUsers: true));
                }),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
          ],
        ),
        body: CategoryList());
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryList createState() => _CategoryList();
}

class _CategoryList extends State<CategoryList>
    with AutomaticKeepAliveClientMixin<CategoryList> {
  //_TrendingSnackItem({Key key, this.item}) : super(key: key);
  List<SnackItem> trendingSnacks;

  void hasResults(value) {
    print("got snacks");

    setState(() {
      trendingSnacks = value;
    });
  }

  @override
  void initState() {
    print("getting charts");
    SnaxBackend.chartTrending().then(hasResults);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getList(context, trendingSnacks);
  }

  @override
  bool get wantKeepAlive => true;
}
