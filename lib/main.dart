import 'package:flutter/material.dart';

import 'puzzle_app.dart';
import 'sound.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Sound.instance.load();

  runApp(const PuzzleApp());
}
