import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';

class BarcodeAddSearch extends SearchDelegate<String> {
  Function callback;
  bool confirmDialog = false;
  bool popOnCallback = true;

  BarcodeAddSearch(this.callback, {this.confirmDialog, this.popOnCallback});

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
    if (query.isEmpty)
      return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              {'label': "Trending Snacks", 'func': SnaxBackend.chartTrending()},
              {'label': "Top Snacks", 'func': SnaxBackend.chartTop()}
            ]
                .map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 24.0, bottom: 8),
                          child: Text(e["label"]),
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<SnackItem> snacks = snapshot.data;
                              return SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    clipBehavior: Clip.none,
                                    itemBuilder: (context, i) => Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            (i == 0) ? 16 : 12,
                                            8,
                                            (i == snacks.length - 1) ? 16 : 12,
                                            8),
                                        child: searchPageLilCard(
                                            context, snacks[i], () {
                                          if (this.popOnCallback == true)
                                            Navigator.of(context).pop();
                                          this.callback(SnackSearchResultItem
                                              .fromSnackItem(snacks[i]));
                                        })),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snacks.length,
                                    shrinkWrap: true,
                                  ));
                            } else {
                              return SizedBox(
                                  height: 120,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }
                          },
                          future: e["func"],
                        ),
                      ],
                    ) as Widget)
                .toList() +
            <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 16),
                child: Text("Recent Searches"),
              ),
            ] +
            [
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<String> searches = snapshot.data;
                    return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searches.length,
                        separatorBuilder: (context, i) => Divider(),
                        itemBuilder: (context, i) => ListTile(
                          dense: true,
                            title: Text(
                              searches[i],
                              style: TextStyle(
                                fontSize: 15,
                                  color: Theme.of(context).accentColor),
                            ),
                            onTap: () {
                              this.query = searches[i];
                            },
                            trailing: Icon(
                              Icons.arrow_right,
                              color: Theme.of(context).accentColor,
                            )));
                  } else {
                    return SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()));
                  }
                },
                future: SnaxBackend.recentSearches(),
              )
            ],
      ));

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

                        if (this.confirmDialog == true) {
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
                                        Text(
                                          snacks[i].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text("Is this the right snack?")
                                      ],
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                          textTheme: ButtonTextTheme.accent),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            if (this.popOnCallback == true)
                                              Navigator.of(_context).pop();
                                            this.callback(snacks[i]);
                                          },
                                          child: Text("Confirm"),
                                          textTheme: ButtonTextTheme.primary),
                                    ],
                                  ));
                        } else {
                          if (this.popOnCallback == true) Navigator.of(context).pop();
                          this.callback(snacks[i]);
                        }
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

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor:
          isDark(context) ? SnaxColors.darkGreyGradientEnd : Colors.white,
      brightness: isDark(context) ? Brightness.dark : Brightness.light,
      primaryIconTheme: theme.iconTheme,
      primaryColorBrightness:
          isDark(context) ? Brightness.dark : Brightness.light,
      //textTheme: theme.textTheme
    );
  }
}

Widget searchPageLilCard(
    BuildContext context, SnackItem snack, Function onTap) {
  return Container(
    width: 220,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snack.name,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              Container(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: AspectRatio(
                        aspectRatio: 1, child: Image.network(snack.image)),
                  ),
                  Container(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                                "${(snack.averageRatings.overall ?? 0).toStringAsFixed(1)} ",
                                style: TextStyle(
                                  color: SnaxColors.subtext,
                                )),
                          ),
                          SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              rating: snack.averageRatings.overall ?? 0,
                              size: 17,
                              isReadOnly: true,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              color: SnaxColors.subtext,
                              borderColor: SnaxColors.subtext,
                              spacing: 0.0),
                        ],
                      ),
                      Container(height: 4),
                      Text("${snack.numberOfRatings} Ratings",
                          style: TextStyle(color: SnaxColors.subtext))
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: isDark(context) ? null : Colors.white,
      gradient: isDark(context) ? SnaxGradients.darkGreyCard : null,
      boxShadow: [SnaxShadows.cardShadowSubtler],
    ),
  );
}
