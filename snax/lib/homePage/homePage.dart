import 'package:flutter/material.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/homePage/specificSnack.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

import '../helpers.dart';
import '../themes.dart';
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
                    Theme(
                      data: ThemeData(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent),
                      child: new SliverAppBar(
                        brightness: isDark(context) ? Brightness.dark : Brightness.light,
                        /*flexibleSpace: Container(
                            decoration: BoxDecoration(
                                gradient: SnaxGradients.redBigThings),
                          ),*/
                        elevation: 2,
                        backgroundColor: Theme.of(context).canvasColor,
                        //title: Text("SNAX", style: TextStyle(color: getTheme(context).accentColor)),
                        title: Image.asset("assets/snax.png",height: 19,color: getTheme(context).accentColor,),
                        centerTitle: false,
                        floating: true,
                        pinned: true,
                        snap: true,
                        bottom: TabBar(
                          isScrollable: true,
                          unselectedLabelColor: getTheme(context).accentColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              //gradient: getTheme(context).littleGradient(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: getTheme(context).primaryColor,
                          ),
                          labelStyle: TextStyle(fontSize: 18),
                          labelColor: getTheme(context).primaryContrastForText(),
                          tabs: [
                            Container(width: 80, child: Tab(text: "For You")),
                            Container(width: 80, child: Tab(text: "Trending")),
                            Container(width: 80, child: Tab(text: "Top"))
                          ],
                        ),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.search),
                              color: getTheme(context).accentColor,
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
                                    }, showCards: false, showUsers: true));
                              }),
                          IconButton(
                              icon: Icon(Icons.qr_code_scanner),
                              color: getTheme(context).accentColor,
                              onPressed: () {
                                //Present Widget
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BarcodeScannerPage()));
                              })
                        ],
                        
                      ),
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

  Future forYouPromise = Future.wait([
    SnaxBackend.snackOfTheWeek(),
    SnaxBackend.chartTrending(),
    SnaxBackend.chartTop(),
    SnaxBackend.getSnacksInCategory("chip", SnackListSort.trending),
    SnaxBackend.getSnacksInCategory("cracker", SnackListSort.top),
  ]);

  Widget forYouTab(BuildContext context, List<SnackItem> snackList) {
    return RefreshIndicator(
        onRefresh: () {
          setState(() {
            this.forYouPromise = Future.wait([
              SnaxBackend.snackOfTheWeek(forceRefresh: true),
              SnaxBackend.chartTrending(forceRefresh: true),
              SnaxBackend.chartTop(forceRefresh: true),
              SnaxBackend.getSnacksInCategory("chip", SnackListSort.trending,
                  forceRefresh: true),
              SnaxBackend.getSnacksInCategory("cracker", SnackListSort.top,
                  forceRefresh: true),
            ]);
          });
          return Future.delayed(Duration(seconds: 2));
        },
        child: FutureBuilder(
            future: forYouPromise,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: EdgeInsets.only(top: 12),
                  children: [
                    snackOfTheWeek(context, snapshot.data[0]),
                    getHorizontalList("Trending", context, snapshot.data[1]),
                    getHorizontalList("Top", context, snapshot.data[2]),
                    getMiniHorizontalList(
                        "Trending in Chips", context, snapshot.data[3]),
                    getMiniHorizontalList(
                        "Top in Crackers", context, snapshot.data[4]),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
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
