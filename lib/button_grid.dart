import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:let_me_out/constants.dart';

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
    final isMusicMode = widget.puzzleState.gameState == GameState.musicBox;
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeIn,
      child: GridView.count(
        crossAxisCount: 4,
        children: tiles.map((tile) => _buildGridButton(tile)).toList(),
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

Widget _buildGridButton(Tile tile) {
  final gameState = puzzleStateNotifier.value.gameState;

  if (gameState == GameState.musicBox) {
    return TileButton(
      tile,
      onHover: (isHovering) {
        tile.hover = isHovering;
      },
      onPressed: () {
        Sound.instance.play(tile);
        tile.hover = true;
        Future.delayed(const Duration(milliseconds: hoverTimeMs), () {
          tile.hover = false;
        });
      },
    );
  }

  if (gameState == GameState.solved) {
    return const SizedBox();
  }

  if (tile.value == -1) {
    return DecoratedBox(
      key: tile.key,
      decoration: const BoxDecoration(color: Colors.transparent),
    );
  }

  return TileButton(
    tile,
    onHover: (hover) {
      tile.hover = hover;
    },
    onPressed: gameState == GameState.playing
        ? () {
            HapticFeedback.vibrate();
            puzzleStateNotifier.move(tile);
            Sound.instance.play(tile);
            tile.hover = true;
            Future.delayed(const Duration(milliseconds: hoverTimeMs), () {
              tile.hover = false;
            });
          }
        : null,
  );
}

class TileButton extends StatelessWidget {
  final Tile tile;
  final ValueChanged<bool>? onHover;
  final VoidCallback? onPressed;

  const TileButton(
    this.tile, {
    Key? key,
    this.onHover,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        primary: pinkColor,
        side: const BorderSide(
          style: BorderStyle.none,
        ),
        backgroundColor: tileColor,
        shape: const BeveledRectangleBorder(),
      ),
      onHover: onHover,
      onPressed: onPressed,
    );
  }
}
