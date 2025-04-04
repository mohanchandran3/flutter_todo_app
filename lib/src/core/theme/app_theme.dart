import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  cardTheme: const CardTheme(
  elevation: 2.0,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  )
  );
}