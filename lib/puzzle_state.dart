import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'sound.dart';
import 'tile.dart';

/// The game state enum
enum GameState {
  intro,
  shuffle,
  playing,
  solved,
  musicMode,
}

/// The game state of tiles and state
class PuzzleState {
  final List<Tile> tiles;
  final GameState gameState;

  const PuzzleState(this.tiles, this.gameState);
}

/// A state notifier for GameState.
class PuzzleStateNotifier extends ValueNotifier<PuzzleState> {
  /// initialize state with solved tiles and intro state
  PuzzleStateNotifier() : super(PuzzleState(_solved, GameState.intro));

  // for storing state when in music mode
  PuzzleState? _previousState;

  // the solved tile list
  static final List<Tile> _solved = (List.generate(15, (i) => i)..add(-1))
      .map((i) => Tile(i, GlobalKey()))
      .toList();

  // notes
  static final _notes = [
    'e',
    'f',
    'f#',
    'g',
    'g#',
    'a',
    'a#',
    'b',
    'c',
    'c#',
    'd',
    'd#',
    'e',
    'f',
    'f#',
    'g'
  ];

  // note tile list
  final List<Tile> noteTiles =
      List.generate(16, (i) => Tile(i, GlobalKey(), title: _notes[i]));

  /// shuffle the tiles
  void shuffle() async {
    List<Tile> shuffled = List.from(_solved)..shuffle();

    while (isSolved(shuffled)) {
      shuffled.shuffle();
    }

    // add new tiles one by one
    List<Tile> newTiles = [];
    for (Tile tile in shuffled) {
      newTiles.add(Tile(tile.value, tile.key));
      value = PuzzleState(newTiles, GameState.shuffle);
      if (tile.value != -1) {
        Sound.instance.play(tile);
      }
      await Future.delayed(const Duration(milliseconds: shuffleTimeMs));
    }
    value = PuzzleState(newTiles, GameState.shuffle);
    value = PuzzleState(newTiles, GameState.playing);
  }

  /// determine if puzzle is solved
  bool isSolved(List<Tile> tiles) {
    return (List.generate(16, (i) => i)
        .every((i) => tiles[i].value == _solved[i].value));
  }

  /// move tile to empty space
  void move(Tile tile) async {
    List<Tile> tiles = value.tiles;
    final index = tiles.indexWhere((t) => t.value == tile.value);
    final col = index % 4;
    final row = index ~/ 4;

    final emptyIndex = tiles.indexWhere((t) => t.value == -1);
    final emptyCol = emptyIndex % 4;
    final emptyRow = emptyIndex ~/ 4;

    final colDist = (col - emptyCol).abs();
    final rowDist = (row - emptyRow).abs();

    tile.hover = false;

    // are we one tile away from the empty space?
    if (colDist == 1 && rowDist == 0 || rowDist == 1 && colDist == 0) {
      Tile emptyTile = tiles[emptyIndex];

      Offset tileOrigin = tile.origin;
      Offset emptyTileOrigin = emptyTile.origin;

      // swizzle tile origins (and ready them for simulation)
      tile.origin = emptyTileOrigin;
      emptyTile.origin = tileOrigin;

      tiles[index] = emptyTile;
      tiles[emptyIndex] = tile;

      if (isSolved(tiles)) {
        for (Tile tile in tiles) {
          tile.velocity = _getRandomExplosionVector();
          tile.solved = true;
          value = PuzzleState(tiles, GameState.solved);
          if (tile.value != -1) {
            Sound.instance.play(tile);
          }
          await Future.delayed(const Duration(milliseconds: shuffleTimeMs));
        }
        value = PuzzleState(tiles, GameState.solved);
      } else {
        value = PuzzleState(tiles, GameState.playing);
      }
    }
  }

  Offset _getRandomExplosionVector() {
    final vel = Random().nextDouble() * 300.0 + 100.0;
    final angle = Random().nextDouble() * pi + pi;
    return Offset(cos(angle), sin(angle)) * vel;
  }

  void toggleMusicMode() {
    if (value.gameState == GameState.musicMode) {
      value = _previousState ?? PuzzleState(_solved, GameState.intro);
    } else {
      _previousState = value;
      value = PuzzleState(noteTiles, GameState.musicMode);
    }
  }
}

/// The puzzle state notifier
final puzzleStateNotifier = PuzzleStateNotifier();
