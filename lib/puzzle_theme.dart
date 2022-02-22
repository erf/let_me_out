import 'package:flutter/material.dart';

final themeData = ThemeData(
  primaryColor: Colors.black,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.black),
      overlayColor: MaterialStateProperty.all(Colors.black.withAlpha(20)),
      enableFeedback: true,
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Major Mono Display',
      ),
);
