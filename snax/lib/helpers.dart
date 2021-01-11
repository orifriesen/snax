import 'dart:ui';
import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

abstract class SnaxColors {
  static Color gradientStart = HexColor.fromHex("FF4B2B");
  static Color gradientEnd = HexColor.fromHex("FF416C");

  static Color darkGreyGradientStart = HexColor.fromHex("3C3C3C");
  static Color darkGreyGradientEnd = HexColor.fromHex("2C2C2C");

  static Color redAccent = HexColor.fromHex("FF4844");

  static Color subtext = HexColor.fromHex("ABABAB");
}

abstract class SnaxGradients {
  //big backdrops and splashes
  static LinearGradient redBigThings = LinearGradient(
      begin: Alignment(0, -0.5),
      end: Alignment(1, 1.5),
      colors: [SnaxColors.gradientStart, SnaxColors.gradientEnd]);

  //buttons and stuff, more subdued and less dramatic
  static LinearGradient redLittleThings = LinearGradient(
      begin: Alignment(-0.5, -1.5),
      end: Alignment(1.5, 2.5),
      colors: [SnaxColors.gradientStart, SnaxColors.gradientEnd]);

  //buttons and stuff, more subdued and less dramatic
  static LinearGradient darkGreyCard = LinearGradient(
      begin: Alignment(0, -0.2),
      end: Alignment(0, 1.5),
      colors: [
        SnaxColors.darkGreyGradientStart,
        SnaxColors.darkGreyGradientEnd
      ]);
}

abstract class SnaxShadows {
  static BoxShadow cardShadow =
      BoxShadow(color: Color.fromARGB(36, 0, 0, 0), blurRadius: 12);
  static BoxShadow cardShadowSubtler =
      BoxShadow(color: Color.fromARGB(20, 0, 0, 0), blurRadius: 10);
}

MaterialButton SnaxButton(String title, Color color, Function tap) =>
    MaterialButton(
      color: color,
      textColor: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      height: 58,
      minWidth: double.infinity,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
      onPressed: tap,
      child: Text(
        title,
        style: TextStyle(fontSize: 15),
      ),
    );

bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

