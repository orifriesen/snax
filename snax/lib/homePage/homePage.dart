import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:number_display/number_display.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/specificSnack.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

import '../helpers.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    return getHorizontalList(context, trendingSnacks);
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

Widget getHorizontalList(BuildContext context, List<SnackItem> snackList) {
  final display = createDisplay(placeholder: '0');

  return Column(
    children: [
      Text("horizontal list"),
      Container(
          margin: EdgeInsets.all(20.0),
          height: 200.0,
          child: ListView.builder(
              itemCount: snackList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                    decoration: BoxDecoration(
                        color: isDark(context)
                            ? SnaxColors.darkGreyGradientEnd
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(36, 0, 0, 0),
                              blurRadius: 12)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            clipBehavior: Clip.hardEdge,
                            padding: EdgeInsets.all(2),
                            height: 64,
                            width: 64,
                            child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.network(snackList[1].image)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: Text(
                                    snackList[1].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(
                                    children: [
                                      Text(snackList[1].type.name,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400])),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.grey[400],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                      display(snackList[1].numberOfRatings) +
                                          " total ratings",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400])),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
              }))
    ],
  );
}

Widget getList(BuildContext context, List<SnackItem> snackList) {
  final List<SnackItem> trendingSnacks = snackList;
  final display = createDisplay(placeholder: '0');

  return Column(
    children: [
      Expanded(
          child: trendingSnacks != null
              ? ListView.builder(
                  padding: EdgeInsets.only(top: 12),
                  itemCount: trendingSnacks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                        item: trendingSnacks[index])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isDark(context)
                                    ? SnaxColors.darkGreyGradientEnd
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(24, 0, 0, 0),
                                      blurRadius: 8)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white),
                                    clipBehavior: Clip.hardEdge,
                                    padding: EdgeInsets.all(2),
                                    height: 64,
                                    width: 64,
                                    child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: Image.network(
                                            trendingSnacks[index].image)),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 1.0),
                                              child: Text(
                                                trendingSnacks[index].name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              trendingSnacks[
                                                                      index]
                                                                  .type
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                          .grey[
                                                                      400])),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Text(
                                                          display(trendingSnacks[
                                                                      index]
                                                                  .numberOfRatings) +
                                                              " total ratings",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[400])),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            trendingSnacks[
                                                                    index]
                                                                .averageRatings
                                                                .overall
                                                                .toStringAsFixed(
                                                                    1),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .grey)),
                                                        Icon(Icons.star_rounded,
                                                            size: 26,
                                                            color: SnaxColors
                                                                .redAccent)
                                                      ],
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  })
              : Container(
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(SnaxColors.redAccent),
                  )),
                )),
    ],
  );
}
