import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:snax/helpers.dart';

class SnaxTheme {
  String id;
  String name;
  Color primaryColor;
  Color accentColor;
  Color gradientStart;
  Color gradientEnd;
  Color appBarColor;
  LinearGradient bigGradient() => LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment(0, -0.5),
        end: Alignment(1, 1.5),
      );
  LinearGradient littleGradient() => LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment(-0.5, -1.5),
        end: Alignment(1.5, 2.5),
      );
  SnaxTheme(this.id, this.name, this.primaryColor, this.accentColor,
      this.gradientStart, this.gradientEnd, this.appBarColor);
}

final List<SnaxTheme> lightThemeList = [
  SnaxTheme(
      "red",
      "Flamin' Hot",
      HexColor.fromHex("FF4844"),
      HexColor.fromHex("FF4844"),
      HexColor.fromHex("FF4B2B"),
      HexColor.fromHex("FF416C"),
      HexColor.fromHex("FF4B2B")),
  SnaxTheme(
      "green",
      "Kale",
      HexColor.fromHex("91C55D"),
      HexColor.fromHex("91C55D"),
      HexColor.fromHex("6CA944"),
      HexColor.fromHex("B2DD73"),
      HexColor.fromHex("6CA944")),
];

final List<SnaxTheme> darkThemeList = [
  SnaxTheme(
      "red",
      "Flamin' Hot",
      HexColor.fromHex("FF4844"),
      HexColor.fromHex("FF4844"),
      HexColor.fromHex("FF4B2B"),
      HexColor.fromHex("FF416C"),
      HexColor.fromHex("FF4B2B")),
  SnaxTheme(
      "purple",
      "Midnight Snacking",
      HexColor.fromHex("625E99"),
      HexColor.fromHex("625E99"),
      HexColor.fromHex("614385"),
      HexColor.fromHex("516395"),
      HexColor.fromHex("5B4F8B")),
];

SnaxTheme currentLightTheme = lightThemeList[0];
SnaxTheme currentDarkTheme = darkThemeList[0];

SnaxTheme getTheme(BuildContext context) =>
    isDark(context) ? currentDarkTheme : currentLightTheme;
