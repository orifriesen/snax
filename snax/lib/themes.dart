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
  Color overrideTextColor;
  Brightness overrideBrightness;
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

  Color primaryContrastForText() =>
      overrideTextColor ??
      (primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);
  Color accentContrastForText() =>
      overrideTextColor ??
      (accentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);
  Color appBarContrastForText() =>
      overrideTextColor ??
      (appBarColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);
  Brightness appBarBrightness() =>
      overrideBrightness ??
      (appBarColor.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark);

  SnaxTheme(this.id, this.name, this.primaryColor, this.accentColor,
      this.gradientStart, this.gradientEnd, this.appBarColor,
      {this.overrideTextColor, this.overrideBrightness});
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
  SnaxTheme(
      "pink",
      "Ori's Theme",
      HexColor.fromHex("FF1493"),
      HexColor.fromHex("FF1493"),
      HexColor.fromHex("ec008c"),
      HexColor.fromHex("e14fad"),
      HexColor.fromHex("ec008c")),
  SnaxTheme(
      "blue",
      "Blue Raspberry",
      HexColor.fromHex("0083B0"),
      HexColor.fromHex("0083B0"),
      HexColor.fromHex("00B4DB"),
      HexColor.fromHex("0083B0"),
      HexColor.fromHex("0083B0")),
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
  SnaxTheme(
    "green",
    "Kale",
    HexColor.fromHex("91C55D"),
    HexColor.fromHex("91C55D"),
    HexColor.fromHex("6CA944"),
    HexColor.fromHex("B2DD73"),
    HexColor.fromHex("6CA944"),
  ),
  SnaxTheme(
    "escher",
    "Escher's Theme",
    HexColor.fromHex("FED8DD"),
    HexColor.fromHex("FED8DD"),
    HexColor.fromHex("ee9ca7"),
    HexColor.fromHex("ffdde1"),
    HexColor.fromHex("F7BCC3"),
  ),
];

SnaxTheme currentLightTheme = lightThemeList[0];
SnaxTheme currentDarkTheme = darkThemeList[0];

SnaxTheme getTheme(BuildContext context) =>
    isDark(context) ? currentDarkTheme : currentLightTheme;
