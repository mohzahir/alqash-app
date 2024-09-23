import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Bahij_TheSansArabic',
  primaryColor: const  Color(0xff23CB60),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFF9E9E9E),
  colorScheme: const ColorScheme.light(primary: Color(0xff23CB60),
    secondary:  Color(0xff23CB60),
    tertiary: Color(0xFFF9D4A8),tertiaryContainer:  Color(0xff23CB60),
    onTertiaryContainer: Color(0xFF33AF74),
    primaryContainer:  Color(0xff23CB60),secondaryContainer: Color(0xFFF2F2F2),),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);