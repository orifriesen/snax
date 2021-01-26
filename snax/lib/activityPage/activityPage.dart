import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snax/backend/requests.dart';
import 'package:snax/feedPage/makePostPage.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/helpers.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with AutomaticKeepAliveClientMixin<ActivityPage> {
  @override
  bool get wantKeepAlive => true;

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isScrolled) => [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  centerTitle: true,
                  leadingWidth: double.infinity,
                  leading: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 16.0),
                      child: Text("Activity",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 75, 43),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ))),
                  actions: [],
                ),
              ],
          body: Center(child: Text("test"))),
    );
  }
}
