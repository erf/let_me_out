import 'package:flutter/material.dart';
import 'package:let_me_out/constants.dart';

import 'puzzle_state.dart';

class ShuffleButton extends StatefulWidget {
  final PuzzleState puzzleState;

  const ShuffleButton(
    this.puzzleState, {
    Key? key,
  }) : super(key: key);

  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {
  bool initializing = true;
  double turns = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((delayed) {
      setState(() {
        initializing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimatedButton();
  }

  Widget _buildAnimatedButton() {
    bool isMusicMode = widget.puzzleState.gameState == GameState.musicMode;
    bool shuffeling = widget.puzzleState.gameState == GameState.shuffle;
    bool disable = shuffeling || initializing || isMusicMode;
    return AnimatedRotation(
      turns: turns,
      duration: const Duration(milliseconds: fadeInTimeMs),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: disable ? 0.0 : 1.0,
        duration: const Duration(milliseconds: fadeInTimeMs),
        curve: Curves.easeInCubic,
        child: _buildButton(disable),
      ),
    );
  }

  IgnorePointer _buildButton(bool disable) {
    return IgnorePointer(
      ignoring: disable,
      child: IconButton(
        icon: const Icon(
          Icons.refresh,
          color: Colors.black38,
          size: 17,
        ),
        onPressed: () {
          puzzleStateNotifier.shuffle();
          setState(() {
            turns += 1.0;
          });
        },
      ),
    );
  }
}
