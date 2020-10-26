import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';
import 'package:snax/barcodeScanner/barcodeAddCode.dart';

class MakePostPage extends StatefulWidget {
  @override
  _MakePostPageState createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
  SnackSearchResultItem snack;
  void chooseNewSnack() {
    showSearch(
        context: context,
        delegate: BarcodeAddSearch((SnackSearchResultItem returnSnack) {
          setState(() {
            this.snack = returnSnack;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Make a Post"),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Post",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Column(
        children: [
          (snack == null)
              ? ListTile(
                  title: Text("Choose Snack"),
                  trailing: Icon(Icons.arrow_drop_down_rounded),
                  onTap: chooseNewSnack,
                )
              : ListTile(
                  leading: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(
                        snack.image,
                        scale: 5,
                      )),
                  title: Text(snack.name),
                  subtitle: Text("Choose Other Snack"),
                  trailing: Icon(Icons.arrow_drop_down_outlined),
                  onTap: chooseNewSnack),
          TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                  hintText: 'Post Title')),
          Expanded(
            child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    hintText: 'What\'s your opinion on this snack?')),
          )
        ],
      ),
    );
  }
}
