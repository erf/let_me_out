import 'package:flutter/material.dart';

import 'puzzle_state.dart';

class ShuffleButton extends StatelessWidget {
  final PuzzleState puzzleState;

  const ShuffleButton(
    this.puzzleState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.refresh,
        color: Colors.black38,
        size: 18,
      ),
      onPressed: () {
        puzzleStateNotifier.shuffle();
      },
    );
  }
}
