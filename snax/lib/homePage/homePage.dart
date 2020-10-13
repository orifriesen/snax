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

class TrendingList extends StatefulWidget {
  @override
  _TrendingListState createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  final items = TrendingSnackList.getProducts();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: TrendingSnackItem(item: items[index]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(item: items[index])));
            });
      },
    );
  }
}

Widget getTabBarPages() {
  return TabBarView(
    children: [TrendingList(), TrendingList()],
  );
}

class TrendingSnackItem extends StatelessWidget {
  TrendingSnackItem({Key key, this.item}) : super(key: key);
  final TrendingSnackList item;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 100,
        child: Card(
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
                        child: Image.asset("assets/" + this.item.image,
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
                          Text(this.item.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16)),
                          Text(this.item.categories,
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          Row(children: <Widget>[
                            Text(this.item.rating.toStringAsFixed(1) + " ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16)),
                            SmoothStarRating(
                                allowHalfRating: true,
                                starCount: 5,
                                rating: this.item.rating,
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
        )));
  }
}
