import 'package:flutter/material.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/homePage/specificSnack.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

import '../helpers.dart';
import 'homePageFunctions.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  SnackItem chosenSnack;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
            body: new NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    new SliverAppBar(
                      /*flexibleSpace: Container(
                          decoration: BoxDecoration(
                              gradient: SnaxGradients.redBigThings),
                        ),*/
                      elevation: 2,
                      backgroundColor: Theme.of(context).canvasColor,
                      title: Text("SNAX",
                          style: TextStyle(color: SnaxColors.redAccent)),
                      floating: true,
                      pinned: true,
                      snap: true,
                      bottom: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: SnaxColors.redAccent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                            gradient: SnaxGradients.redBigThings,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.redAccent),
                        labelStyle: TextStyle(fontSize: 18),
                        tabs: [
                          Container(width: 80, child: Tab(text: "For You")),
                          Container(width: 80, child: Tab(text: "Trending")),
                          Container(width: 80, child: Tab(text: "Top"))
                        ],
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.search),
                            color: SnaxColors.redAccent,
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: BarcodeAddSearch(
                                      (SnackSearchResultItem
                                          returnSnack) async {
                                    chosenSnack = await SnaxBackend.getSnack(
                                        returnSnack.id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductPage(
                                                item: chosenSnack)));
                                  }));
                            }),
                        IconButton(
                            icon: Icon(Icons.qr_code_scanner),
                            color: SnaxColors.redAccent,
                            onPressed: () {
                              //Present Widget
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BarcodeScannerPage()));
                            })
                      ],
                      centerTitle: true,
                    ),
                  ];
                },
                body: getTabBarPages())));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget getTabBarPages() {
  return TabBarView(
    children: [ForYou(), TrendingList(), TopList()],
  );
}

class ForYou extends StatefulWidget {
  @override
  _ForYou createState() => _ForYou();
}

class _ForYou extends State<ForYou> with AutomaticKeepAliveClientMixin<ForYou> {
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
    return forYouTab(context, trendingSnacks);
  }

  @override
  bool get wantKeepAlive => true;
}

class TrendingList extends StatefulWidget {
  @override
  _TrendingList createState() => _TrendingList();
}

class _TrendingList extends State<TrendingList>
    with AutomaticKeepAliveClientMixin<TrendingList> {
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

class TopList extends StatefulWidget {
  @override
  _TopList createState() => _TopList();
}

class _TopList extends State<TopList>
    with AutomaticKeepAliveClientMixin<TopList> {
  //_TrendingSnackItem({Key key, this.item}) : super(key: key);
  List<SnackItem> topSnacks;

  void hasResults(value) {
    print("got snacks");

    setState(() {
      topSnacks = value;
    });
  }

  @override
  void initState() {
    print("getting charts");
    SnaxBackend.chartTop().then(hasResults);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getList(context, topSnacks);
  }

  @override
  bool get wantKeepAlive => true;
}

Widget forYouTab(BuildContext context, List<SnackItem> snackList) {
  return snackList != null
      ? ListView(
          padding: EdgeInsets.only(top: 12),
          children: [
            snackOfTheWeek(context, snackList[0]),
            getHorizontalList("Trending", context, snackList),
            getHorizontalList("Top", context, snackList),
            getMiniHorizontalList("Test", context, snackList)
          ],
        )
      : Container(
          child: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(SnaxColors.redAccent),
          )),
        );
}
