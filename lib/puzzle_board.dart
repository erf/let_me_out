import 'dart:math';

import 'package:flutter/material.dart';

import 'puzzle_state.dart';
import 'shuffle_button.dart';
import 'puzzle_message.dart';
import 'button_grid.dart';
import 'physics_grid.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const minSize = 400.0;
    final size = MediaQuery.of(context).size;
    final maxSize = min(minSize, min(size.width, size.height));

    return Center(
      child: ValueListenableBuilder<PuzzleState>(
        valueListenable: puzzleStateNotifier,
        builder: (context, puzzleState, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: maxSize,
                height: maxSize,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ButtonGrid(puzzleState),
                      PhysicsGrid(puzzleState),
                      PuzzleMessage(puzzleState),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ShuffleButton(puzzleState),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
