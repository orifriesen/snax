import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:number_display/number_display.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/homePage/specificSnack.dart';

import '../helpers.dart';

Widget getHorizontalList(
    String titleText, BuildContext context, List<SnackItem> snackList) {
  final display = createDisplay(placeholder: '0');

  return Column(
    children: [
      GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titleText,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Icon(Icons.arrow_forward_ios_rounded, size: 22)
            ],
          ),
        ),
      ),
      SizedBox(
        height: 250,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: snackList != null
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snackList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 260,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                              item: snackList[index])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // padding: EdgeInsets.all(1),
                                        width: 240,
                                        height: 114,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: (snackList[index].banner !=
                                                      null)
                                                  ? Image.network(
                                                      snackList[index].banner)
                                                  : Image.asset(
                                                      "assets/placeholderImage.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            Container(
                                                child: Opacity(
                                                  opacity: 0.5,
                                                  child: Image.asset(
                                                      'assets/snax-chip.png'),
                                                ),
                                                height: 21,
                                                padding: EdgeInsets.only(
                                                    left: 200, top: 10)),
                                          ],
                                        ),
                                      ),
                                      Container(height: 12),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            clipBehavior: Clip.hardEdge,
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white),
                                            child: AspectRatio(
                                                aspectRatio: 1,
                                                child: Image.network(
                                                    snackList[index].image)),
                                          ),
                                          Container(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snackList[index].name,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                    child: Text(
                                                        "${(snackList[index].averageRatings.overall ?? 0).toStringAsFixed(1)} ",
                                                        style: TextStyle(
                                                          color: SnaxColors
                                                              .subtext,
                                                        )),
                                                  ),
                                                  SmoothStarRating(
                                                      allowHalfRating: true,
                                                      starCount: 5,
                                                      rating: snackList[index]
                                                              .averageRatings
                                                              .overall ??
                                                          0,
                                                      size: 17,
                                                      isReadOnly: true,
                                                      defaultIconData: Icons
                                                          .star_border_rounded,
                                                      filledIconData:
                                                          Icons.star_rounded,
                                                      halfFilledIconData: Icons
                                                          .star_half_rounded,
                                                      color:
                                                          SnaxColors.redAccent,
                                                      borderColor:
                                                          SnaxColors.redAccent,
                                                      spacing: 0.0),
                                                ],
                                              ),
                                              Container(height: 2),
                                              Text(
                                                  "${snackList[index].numberOfRatings} Ratings",
                                                  style: TextStyle(
                                                      color:
                                                          SnaxColors.subtext))
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
                              gradient: isDark(context)
                                  ? SnaxGradients.darkGreyCard
                                  : null,
                              boxShadow: [SnaxShadows.cardShadowSubtler],
                            ),
                          ));
                    })
                : Container(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          SnaxColors.redAccent),
                    )),
                  )),
      )
    ],
  );
}

Widget getMiniHorizontalList(
    String titleText, BuildContext context, List<SnackItem> snackList) {
  final display = createDisplay(placeholder: '0');

  return Column(
    children: [
      GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titleText,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Icon(Icons.arrow_forward_ios_rounded, size: 22)
            ],
          ),
        ),
      ),
      SizedBox(
        height: 220,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: snackList != null
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snackList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 120,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                              item: snackList[index])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 86,
                                        height: 86,
                                        clipBehavior: Clip.hardEdge,
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                                snackList[index].image)),
                                      ),
                                      Container(height: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snackList[index].name,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Text(
                                                    "${(snackList[index].averageRatings.overall ?? 0).toStringAsFixed(1)} ",
                                                    style: TextStyle(
                                                      color: SnaxColors.subtext,
                                                    )),
                                              ),
                                              Icon(Icons.star_rounded,
                                                  color: SnaxColors.redAccent,
                                                  size: 16)
                                            ],
                                          ),
                                          Container(height: 2),
                                          Text(
                                              "${snackList[index].numberOfRatings} Ratings",
                                              style: TextStyle(
                                                  color: SnaxColors.subtext))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isDark(context) ? null : Colors.white,
                              gradient: isDark(context)
                                  ? SnaxGradients.darkGreyCard
                                  : null,
                              boxShadow: [SnaxShadows.cardShadowSubtler],
                            ),
                          ));
                    })
                : Container(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          SnaxColors.redAccent),
                    )),
                  )),
      )
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

Widget snackOfTheWeek(BuildContext context, SnackItem snackItem) {
  final display = createDisplay(placeholder: '0');

  return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductPage(item: snackItem)));
          },
          child: Stack(children: [
            Container(
                decoration: BoxDecoration(
                    color:
                        /*isDark(context)
                      ? SnaxColors.darkGreyGradientEnd
                      : Colors.white,*/
                        Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(24, 0, 0, 0), blurRadius: 8)
                    ]),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(snackItem.banner))),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Snack of the Week:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Container(height: 2),
                  Text(snackItem.name + "!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Container(height: 2),
                  Row(
                    children: [
                      Text(snackItem.averageRatings.overall.toStringAsFixed(1),
                          style: TextStyle(fontSize: 20)),
                      Icon(
                        Icons.star_rounded,
                        color: SnaxColors.redAccent,
                        size: 28,
                      )
                    ],
                  )
                ],
              ),
            )
          ])));
}
