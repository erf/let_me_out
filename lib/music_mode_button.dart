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
        color: isMusicMode ? Colors.black38 : Colors.black12,
        size: 17,
      ),
      onPressed: () {
        puzzleStateNotifier.toggleMusicMode();
      },
    );
  }
}
