import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SnackSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(onSearch: null, onItemFound: null),
        ),
      ),
    );
  }
}
