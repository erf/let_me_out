import 'package:flutter/material.dart';

import 'constants.dart';
import 'puzzle_state.dart';

class MusicModeButton extends StatefulWidget {
  final PuzzleState puzzleState;

  const MusicModeButton(this.puzzleState, {Key? key}) : super(key: key);

  @override
  _MusicModeButtonState createState() => _MusicModeButtonState();
}

class _MusicModeButtonState extends State<MusicModeButton> {
  bool initializing = true;

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
    bool isMusicMode = widget.puzzleState.gameState == GameState.musicMode;
    bool shuffeling = widget.puzzleState.gameState == GameState.shuffle;
    bool disable = shuffeling || initializing;
    return IgnorePointer(
      ignoring: disable,
      child: AnimatedOpacity(
        opacity: disable ? 0.0 : 1.0,
        duration: const Duration(milliseconds: fadeInTimeMs),
        curve: Curves.easeInCubic,
        child: IconButton(
          icon: Icon(
            Icons.music_note_outlined,
            color: isMusicMode ? pinkColor : pinkDisabled,
            size: 17,
          ),
          onPressed: () {
            puzzleStateNotifier.toggleMusicMode();
          },
        ),
      ),
    );
  }
}
