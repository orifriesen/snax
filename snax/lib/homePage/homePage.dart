import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/homePage/searchBar.dart';
import 'package:snax/homePage/specificSnack.dart';
import 'snackList.dart';

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SnackSearch()));
                })
          ],
          centerTitle: true,
        ),
        body: getTabBarPages());
  }
}

Widget getTabBarPages() {
  return TabBarView(
    children: [TrendingList(), TrendingList()],
  );
}

class TrendingList extends StatefulWidget {
  @override
  _TrendingSnackItem createState() => _TrendingSnackItem();
}

class _TrendingSnackItem extends State<TrendingList> {
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
    SnaxBackend.chartTop().then(hasResults);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: trendingSnacks != null ? trendingSnacks.length : 0,
          itemBuilder: (context, index) {
            return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductPage(item: trendingSnacks[index])));
                },
                leading: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          child: Align(
                              alignment: Alignment.center,
                              widthFactor: .66,
                              heightFactor: 1.0,
                              child: Image.asset("assets/placeholderImage.jpg",
                                  width: 75, height: 75)),
                        ))),
                title: Text(this.trendingSnacks[index].name),
                subtitle:
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(this
                      .trendingSnacks[index]
                      .averageRatings
                      .overall
                      .toStringAsFixed(1)),
                  SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: this.trendingSnacks[index].averageRatings.overall,
                      size: 20.0,
                      isReadOnly: true,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      spacing: 0.0)
                ]));

            /*Card(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(48, 12, 24, 12),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        child: Align(
                            alignment: Alignment.center,
                            widthFactor: .66,
                            heightFactor: 1.0,
                            child: Image.asset("assets/placeholderImage.jpg",
                                width: 75, height: 75)),
                      )),
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 16, 12, 12),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(this.trendingSnacks[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 16)),
                              Text(this.trendingSnacks[index].type.name,
                                  style: TextStyle(fontWeight: FontWeight.w300)),
                              Row(children: <Widget>[
                                Text(
                                    this
                                            .trendingSnacks[index]
                                            .averageRatings
                                            .overall
                                            .toStringAsFixed(1) +
                                        " ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16)),
                                SmoothStarRating(
                                    allowHalfRating: true,
                                    starCount: 5,
                                    rating: this
                                        .trendingSnacks[index]
                                        .averageRatings
                                        .overall,
                                    size: 20.0,
                                    isReadOnly: true,
                                    filledIconData: Icons.star,
                                    halfFilledIconData: Icons.star_half,
                                    color: Colors.amber,
                                    borderColor: Colors.amber,
                                    spacing: 0.0)
                              ])
                            ])))
              ],
            ));*/
          }),
    );
  }
}
