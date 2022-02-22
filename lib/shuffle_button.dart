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
    bool disable = puzzleState.gameState == GameState.shuffle;
    return AnimatedOpacity(
      opacity: disable ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: disable,
        child: IconButton(
          icon: const Icon(
            Icons.refresh,
            color: Colors.black38,
            size: 18,
          ),
          onPressed: () {
            puzzleStateNotifier.shuffle();
          },
        ),
      ),
    );
  }
}
