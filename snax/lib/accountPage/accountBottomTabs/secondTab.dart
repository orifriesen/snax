import 'package:flutter/material.dart';
import 'package:sup/quick_sup.dart';

class ReviewedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: QuickSup.error(
        image: Center(child: Text("🚧", style: TextStyle(fontSize: 32))),
        title: "Coming Soon",
        subtitle: "The Reviewed tab is currently under construction",
      ),
    );
  }
}
