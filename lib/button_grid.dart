import 'package:flutter/material.dart';

import 'puzzle_state.dart';
import 'sound.dart';
import 'tile.dart';

class ButtonGrid extends StatefulWidget {
  const ButtonGrid(
    this.puzzleState, {
    Key? key,
  }) : super(key: key);

  final PuzzleState puzzleState;

  @override
  State<ButtonGrid> createState() => _ButtonGridState();
}

class _ButtonGridState extends State<ButtonGrid> {
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
    final tiles = widget.puzzleState.tiles;
    final isMusicMode = widget.puzzleState.gameState == GameState.musicMode;
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeIn,
      child: GridView.count(
        crossAxisCount: 4,
        children: tiles.map((tile) => GridButton(tile)).toList(),
        mainAxisSpacing: 24.0,
        crossAxisSpacing: 24.0,
        childAspectRatio: 1.0,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        reverse: isMusicMode,
      ),
    );
  }
}

class GridButton extends StatelessWidget {
  final Tile tile;

  const GridButton(
    this.tile, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (puzzleStateNotifier.value.gameState == GameState.musicMode) {
      return _buildMusicButton();
    }
    return _buildPuzzleButton();
  }

  Widget _buildPuzzleButton() {
    final isSolved = puzzleStateNotifier.value.gameState == GameState.solved;
    if (isSolved) {
      return const SizedBox();
    }
    if (tile.value == -1) {
      return DecoratedBox(
        key: tile.key,
        decoration: const BoxDecoration(color: Colors.transparent),
      );
    }
    return OutlinedButton(
      key: tile.key,
      child: Text(
        tile.value.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSolved ? Colors.black26 : Colors.black87,
          fontSize: 14,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          style: BorderStyle.none,
        ),
        backgroundColor: Colors.black.withAlpha(isSolved ? 0 : 8),
        shape: const BeveledRectangleBorder(),
      ),
      onHover: (isHovering) async {
        tile.hover = isHovering;
      },
      onPressed: puzzleStateNotifier.value.gameState == GameState.playing
          ? () async {
              puzzleStateNotifier.move(tile);
              await Sound.instance.play(tile);
            }
          : null,
    );
  }

  OutlinedButton _buildMusicButton() {
    return OutlinedButton(
      key: tile.key,
      child: Text(
        tile.title ?? tile.value.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          style: BorderStyle.none,
        ),
        backgroundColor: Colors.black.withAlpha(8),
        shape: const BeveledRectangleBorder(),
      ),
      onHover: (isHovering) async {
        tile.hover = isHovering;
      },
      onPressed: () async {
        await Sound.instance.play(tile);
      },
    );
  }
}
