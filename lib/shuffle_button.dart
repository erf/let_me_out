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
  bool visible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((delayed) {
      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool shuffeling = widget.puzzleState.gameState == GameState.shuffle;
    bool disable = visible == false || shuffeling;
    const int shuffleFadeInTimeMs = 250;
    return AnimatedOpacity(
      opacity: disable ? 0.0 : 1.0,
      duration: Duration(
          milliseconds: shuffeling ? shuffleFadeInTimeMs : introFadeInTimeMs),
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
