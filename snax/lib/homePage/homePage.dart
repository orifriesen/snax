import 'package:flutter/material.dart';
import 'package:snax/homePage/specificSnack.dart';
import 'snackList.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [Tab(text: "Trending"), Tab(text: "Top")],
            ),
            title: Text("Snax"),
            actions: <Widget>[
              IconButton(icon: const Icon(Icons.search), onPressed: () {})
            ],
            centerTitle: true,
          ),
          body: getTabBarPages()),
    ));
  }
}

Widget getTabBarPages() {
  final items = SnackList.getProducts();
  return TabBarView(
    children: [
      ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: SnackItem(item: items[index]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPage(item: items[index])));
              });
        },
      ),
      ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: SnackItem(item: items[index]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductPage(item: items[index])));
              });
        },
      ),
    ],
  );
}

class SnackItem extends StatelessWidget {
  SnackItem({Key key, this.item}) : super(key: key);
  final SnackList item;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 140,
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(this.item.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ])))
          ],
        )));
  }
}
