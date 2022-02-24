import 'package:flutter/material.dart';

import 'puzzle_state.dart';

class MusicModeButton extends StatefulWidget {
  final PuzzleState puzzleState;

  const MusicModeButton(this.puzzleState, {Key? key}) : super(key: key);

  @override
  _MusicModeButtonState createState() => _MusicModeButtonState();
}

class _MusicModeButtonState extends State<MusicModeButton> {
  @override
  Widget build(BuildContext context) {
    bool isMusicMode = widget.puzzleState.gameState == GameState.musicMode;

    return IconButton(
      icon: Icon(
        Icons.music_note_outlined,
        color: isMusicMode
            ? Colors.purpleAccent.shade100
            : Colors.purpleAccent.shade100.withAlpha(100),
        size: 17,
      ),
      onPressed: () {
        puzzleStateNotifier.toggleMusicMode();
      },
    );
  }
}
