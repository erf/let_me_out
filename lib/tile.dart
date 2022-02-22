import 'package:flutter/material.dart';

class Tile {
  final int value;
  final GlobalKey key;

  Offset origin = Offset.zero;
  Offset target = Offset.zero;
  Offset position = Offset.zero;
  Offset velocity = Offset.zero;

  bool hover = false;
  bool solved = false;

  Tile(this.value, this.key);
}
