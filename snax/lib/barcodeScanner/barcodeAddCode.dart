import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class BarcodeAddSearch extends SearchDelegate<String> {
  Function callback;

  BarcodeAddSearch(this.callback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return this.buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return StatefulBuilder(
        builder: (context, setState) => FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<SnackSearchResultItem> snacks = snapshot.data;
                return ListView.builder(
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(snacks[i].name),
                      subtitle: Text(
                          (snacks[i].numberOfRatings ?? 0).toString() +
                              " Ratings"),
                      leading: AspectRatio(
                        child: Image.network(snacks[i].image),
                        aspectRatio: 1.0,
                      ),
                      onTap: () {
                        print("tapped");
                        BuildContext _context = context;
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Confirm Choice"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: Container(
                                            height: 100,
                                            child: AspectRatio(
                                              child: Image.network(
                                                  snacks[i].image),
                                              aspectRatio: 1.0,
                                            )),
                                      ),
                                      Text(snacks[i].name,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                      Text("Is this the right snack?")
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"), textTheme: ButtonTextTheme.accent),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(_context).pop();
                                          this.callback(snacks[i]);
                                        },
                                        child: Text("Confirm"),
                                        textTheme: ButtonTextTheme.primary),
                                  ],
                                ));
                      },
                    );
                  },
                  itemCount: snacks.length,
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("An error occurred. Please try again later."));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: SnaxBackend.search(query)));

    // return  ListView.builder(
    //   itemBuilder: (context, index) => ListTile(
    //     onTap: () {
    //       showResults(context);
    //     },
    //     title: RichText(
    //       text: TextSpan(
    //           text: suggestionList[index].substring(0, query.length),
    //           style:
    //               TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    //           children: [
    //             TextSpan(
    //                 text: suggestionList[index].substring(query.length),
    //                 style: TextStyle(color: Colors.grey))
    //           ]),
    //     ),
    //   ),
    //   itemCount: suggestionList.length,
    // );
  }
}
