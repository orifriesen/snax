import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/specificSnack.dart';

import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [Tab(text: "Trending"), Tab(text: "Top")],
          ),
          title: Text("SNAX"),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
          centerTitle: true,
        ),
        drawer: Drawer(),
        body: getTabBarPages());
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

class _TrendingList extends State<TrendingList> {
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
}

class TopList extends StatefulWidget {
  @override
  _TopList createState() => _TopList();
}

class _TopList extends State<TopList> {
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
}

Widget getList(BuildContext context, List<SnackItem> snackList) {
  final List<SnackItem> trendingSnacks = snackList;
  return Expanded(
    child: ListView.builder(
        itemCount: trendingSnacks != null ? trendingSnacks.length : 0,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                              child: Image.network(trendingSnacks[index].image,
                                  width: 80, height: 80)),
                        ))),
                title: Text(
                  trendingSnacks[index].name,
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(" " + trendingSnacks[index].type.name),
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                          rating: trendingSnacks[index].averageRatings.overall,
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
        }),
  );
}
