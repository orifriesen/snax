import 'package:flutter/material.dart';
import 'package:snax/backend/backend.dart';

class MakePostPage extends StatefulWidget {
  SnackItem snack;

  @override
  _MakePostPageState createState() => _MakePostPageState();
}

class _MakePostPageState extends State<MakePostPage> {
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
          (widget.snack == null)
              ? ListTile(
                  title: Text("Choose Snack"),
                  trailing: Icon(Icons.arrow_drop_down_rounded),
                  onTap: () {},
                )
              : ListTile(
                  leading: Image.network(widget.snack.image),
                  title: Text(widget.snack.name),
                  subtitle: Text("Choose Other Snack"),
                  trailing: Icon(Icons.arrow_drop_down_outlined)),
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
