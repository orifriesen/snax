import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';
import 'package:snax/barcodeScanner/barcodeScanner.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/specificSnack.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SnackItem chosenSnack;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
            body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: Text("SNAX"),
                floating: true,
                pinned: true,
                snap: true,
                bottom: TabBar(
                  tabs: [Tab(text: "Trending"), Tab(text: "Top")],
                ),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        /*showSearch(
                            context: context,
                            delegate: BarcodeAddSearch(
                                (SnackSearchResultItem returnSnack) {
                              chosenSnack =
                                  SnaxBackend.getSnack(returnSnack.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductPage(item: chosenSnack)));
                            }));*/
                      }),
                  IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
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
          body: getTabBarPages(),
        )));
  }
}

Widget getTabBarPages() {
  return TabBarView(
    children: [TrendingList(), TopList()],
  );
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

Widget getList(BuildContext context, List<SnackItem> snackList) {
  final List<SnackItem> trendingSnacks = snackList;
  return Expanded(
      child: trendingSnacks != null
          ? ListView.builder(
              itemCount: trendingSnacks.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductPage(item: trendingSnacks[index])));
                      },
                      leading: Container(
                          padding: EdgeInsets.fromLTRB(40, 2, 8, 2),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                color: Colors.white,
                                child: Align(
                                    alignment: Alignment.center,
                                    widthFactor: .66,
                                    heightFactor: 1.0,
                                    child: Image.network(
                                        trendingSnacks[index].image,
                                        width: 80,
                                        height: 80)),
                              ))),
                      title: Text(
                        trendingSnacks[index].name,
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" " + trendingSnacks[index].type.name),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    " " +
                                        trendingSnacks[index]
                                            .averageRatings
                                            .overall
                                            .toStringAsFixed(1),
                                    style: TextStyle(fontSize: 16)),
                                SmoothStarRating(
                                    allowHalfRating: true,
                                    starCount: 5,
                                    rating: trendingSnacks[index]
                                        .averageRatings
                                        .overall,
                                    size: 20.0,
                                    isReadOnly: true,
                                    filledIconData: Icons.star,
                                    halfFilledIconData: Icons.star_half,
                                    color: Colors.amber,
                                    borderColor: Colors.amber,
                                    spacing: 0.0)
                              ]),
                        ],
                      )),
                );
              })
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ));
}
