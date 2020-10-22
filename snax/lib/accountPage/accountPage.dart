import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/backend/requests.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  List<SnackItem> topSnacks;

  void hasResults(value) {
    print("got snacks");

    setState(() {
      topSnacks = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print("getting charts");
    SnaxBackend.chartTop().then(hasResults);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Account"),
        ),
        body: Container(
          child: FutureBuilder(future: SnaxBackend.chartTop(),builder: (BuildContext context,AsyncSnapshot<List<SnackItem>> snapshot) {
            if (snapshot.hasError) {
              // Error
              // snapshot.error is the error that was thrown
              return Text("Error"+snapshot.error.toString());
            } else if (!snapshot.hasData) {
              // Loading
              return Text("Loading");
            } else {
              // Results
              // snapshot.data is the list of snacks
              return ListView.builder(itemBuilder: (BuildContext context,int index) {
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].averageRatings.overall.toString() + "/5 Overall Rating"),
                );
              },itemCount: snapshot.data.length,);
            }
          }),
        ));
  }
}
