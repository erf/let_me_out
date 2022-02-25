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
    bool musicBox = widget.puzzleState.gameState == GameState.musicBox;
    bool shuffeling = widget.puzzleState.gameState == GameState.shuffle;
    bool disable = shuffeling || initializing;
    return AnimatedRotation(
      turns: turns,
      duration: const Duration(milliseconds: fadeInTimeMs),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: disable ? 0.0 : 1.0,
        duration: const Duration(milliseconds: fadeInTimeMs),
        curve: Curves.easeInCubic,
        child: Visibility(
          visible: !musicBox,
          child: _buildButton(disable),
        ),
      ),
    );
  }

  Widget _buildButton(bool disable) {
    return IgnorePointer(
      ignoring: disable,
      child: IconButton(
        icon: const Icon(
          Icons.refresh,
          color: iconColor,
          size: iconSize,
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
