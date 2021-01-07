import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/accountPage/globalAccountPage.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/helpers.dart';
import 'package:sup/quick_sup.dart';

class BarcodeAddSearch extends SearchDelegate<String> {
  Function callback;
  bool confirmDialog = false;
  bool popOnCallback = true;
  bool showCards = true;
  bool showUsers = false;

  BarcodeAddSearch(this.callback,
      {this.confirmDialog = false,
      this.popOnCallback = true,
      this.showCards = true,
      this.showUsers = false});

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
        children: this.showCards
            ? [
                {
                  'label': "Trending Snacks",
                  'func': SnaxBackend.chartTrending()
                },
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
                .toList()
            : <Widget>[] +
                <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 24.0, bottom: 16, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Recent Searches"),
                        FlatButton.icon(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 16,
                            ),
                            onPressed: () {},
                            label: Text("CLEAR",
                                style: TextStyle(
                                  fontSize: 14,
                                ))),
                      ],
                    ),
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
                    future: _getSearchHistory(),
                  )
                ],
      ));

    return StatefulBuilder(builder: (context, setState) {
      return ListView(
        children: [
          FutureBuilder(
              future: SnaxBackend.search(query),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SnackSearchResultItem> snacks = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      snacks.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 24.0, bottom: 8),
                              child: Text(
                                  "Snacks (" + snacks.length.toString() + ")"))
                          : Container(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(snacks[i].name),
                            subtitle: Text(
                                (snacks[i].numberOfRatings ?? 0).toString() +
                                    " Ratings"),
                            leading: AspectRatio(
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white),
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(snacks[i].image)),
                              ),
                              aspectRatio: 1.0,
                            ),
                            onTap: () {
                              print("tapped");
                              BuildContext _context = context;

                              //Add to recent searches
                              _addSearchToHistory(query);

                              if (this.confirmDialog == true) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Confirm Choice"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 16),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                textTheme:
                                                    ButtonTextTheme.accent),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  if (this.popOnCallback ==
                                                      true)
                                                    Navigator.of(_context)
                                                        .pop();
                                                  this.callback(snacks[i]);
                                                },
                                                child: Text("Confirm"),
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ],
                                        ));
                              } else {
                                if (this.popOnCallback == true)
                                  Navigator.of(context).pop();
                                this.callback(snacks[i]);
                              }
                            },
                          );
                        },
                        itemCount: snacks.length,
                      ),
                      (query.length >= 3 && this.showUsers)
                          ? FutureBuilder(
                              future: SnaxBackend.searchUsers(query),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<SnaxUser> users = snapshot.data;

                                  if (users.length == 0 && snacks.length == 0)
                                    return Padding(padding: EdgeInsets.only(top: 44),child: Center(
                                      child: QuickSup.empty(
                                          image: Icon(Icons.search,size: 25,),
                                          title: "No Results",
                                          subtitle: "No snacks or users found"),
                                    ));

                                  return users.length > 0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  top: 24.0,
                                                  bottom: 8),
                                              child: Text("Users (" +
                                                  users.length.toString() +
                                                  ")"),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, i) {
                                                SnaxUser user = users[i];
                                                return ListTile(
                                                  leading: CircleAvatar(
                                                    child: ClipOval(
                                                        child: (user.photo !=
                                                                null)
                                                            ? Image.network(
                                                                user.photo)
                                                            : Image.asset(
                                                                "assets/blank_user.png")),
                                                    radius: 25,
                                                  ),
                                                  title: Text(user.name),
                                                  subtitle:
                                                      Text("@" + user.username),
                                                  onTap: () => {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GlobalAccountPage(
                                                                user),
                                                      ),
                                                    ),
                                                  },
                                                );
                                              },
                                              itemCount: users.length,
                                            )
                                          ],
                                        )
                                      : Container();
                                } else {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, top: 24.0, bottom: 8),
                                          child: Text("Users"),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(44),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ))
                                      ]);
                                }
                              })
                          : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                          Text("An error occurred. Please try again later."));
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 24.0, bottom: 8),
                          child: Text("Snacks"),
                        ),
                        Padding(
                            padding: EdgeInsets.all(44),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                      ]);
                }
              }),
        ],
      );
    });

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
                              defaultIconData: Icons.star_border_rounded,
                              filledIconData: Icons.star_rounded,
                              halfFilledIconData: Icons.star_half_rounded,
                              color: SnaxColors.redAccent,
                              borderColor: SnaxColors.redAccent,
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

Future<List<String>> _getSearchHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> queries = [];
  for (var i = 0; i < 10; i++) {
    var q = prefs.getString('search_history_$i');
    if (q != null) queries.add(q);
  }
  return queries;
}

void _clearSearchHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var i = 0; i < 10; i++) {
    prefs.remove('search_history_$i');
  }
}

void _addSearchToHistory(String query) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Push the rest back
  for (var i = 9; i > 0; i--) {
    prefs.setString(
        'search_history_$i', prefs.getString('search_history_${i - 1}'));
  }
  //Put the new one in front
  prefs.setString('search_history_0', query);
}
