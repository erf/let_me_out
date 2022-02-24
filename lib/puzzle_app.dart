import 'package:flutter/material.dart';

import 'puzzle_board.dart';
import 'puzzle_theme.dart';

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const Material(
        child: PuzzleBoard(),
      ),
    );
  }
}
