import 'dart:math';

import 'package:flutter/material.dart';

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
  PuzzleStateNotifier(value)
      : _stateBeforeMusicMode = value,
        super(value);

  static final List<int> _solved = List.generate(15, (index) => index)..add(-1);

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

  static final List<Tile> noteTiles =
      List.generate(16, (i) => Tile(i, GlobalKey(), title: _notes[i]));

  PuzzleState _stateBeforeMusicMode;

  static const int shuffleTimeMs = 140;

  static createSolvedTiles() {
    return _solved.map((value) => Tile(value, GlobalKey())).toList();
  }

  /// create a new puzzle state with shuffled tiles
  static PuzzleStateNotifier init() {
    return PuzzleStateNotifier(
        PuzzleState(createSolvedTiles(), GameState.intro));
  }

  /// shuffle the tiles
  void shuffle() async {
    List<Tile> tiles = createSolvedTiles();
    List<Tile> shuffled = List.from(tiles)..shuffle();

    do {
      shuffled = List.from(tiles)..shuffle();
    } while (isSolved(shuffled));

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
        .every((i) => tiles[i].value == _solved[i]));
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

    if (colDist == 1 && rowDist == 0 || rowDist == 1 && colDist == 0) {
      Tile emptyTile = tiles[emptyIndex];

      Offset tileOrigin = tile.origin;
      Offset emptyTileOrigin = emptyTile.origin;

      tile.origin = emptyTileOrigin;
      tile.target = emptyTileOrigin;
      tile.position = tileOrigin;
      tile.hover = false;

      emptyTile.origin = tileOrigin;
      emptyTile.position = tileOrigin;
      emptyTile.target = tileOrigin;

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
    bool isMusicMode = value.gameState == GameState.musicMode;

    if (isMusicMode) {
      value = _stateBeforeMusicMode;
    } else {
      _stateBeforeMusicMode = value;
      value = PuzzleState(noteTiles, GameState.musicMode);
    }
  }
}

/// The puzzle state notifier
final puzzleStateNotifier = PuzzleStateNotifier.init();
