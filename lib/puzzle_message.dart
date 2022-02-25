import 'package:flutter/material.dart';
import 'package:let_me_out/constants.dart';

import 'puzzle_state.dart';

/// Show the current state of the game.
class PuzzleMessage extends StatefulWidget {
  final PuzzleState puzzleState;

  const PuzzleMessage(this.puzzleState, {Key? key}) : super(key: key);

  @override
  State<PuzzleMessage> createState() => _PuzzleMessageState();
}

class _PuzzleMessageState extends State<PuzzleMessage> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((delayed) {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = widget.puzzleState.gameState;
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: fadeInTimeMs),
      curve: Curves.easeInCubic,
      child: getMessage(gameState),
    );
  }

  Widget getMessage(GameState gameState) {
    switch (gameState) {
      case GameState.intro:
        return const Text('LeT ME oUt !');
      case GameState.shuffle:
        return const SizedBox.shrink();
      case GameState.playing:
        return const Text('LeT ME oUt !');
      case GameState.solved:
        return const Text('sOLVEd');
      case GameState.musicMode:
        return const Text('MuSiC moDe');
      default:
        return const SizedBox.shrink();
    }
  }
}
