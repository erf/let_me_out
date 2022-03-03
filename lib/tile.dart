import 'dart:math';

import 'package:flutter/material.dart';
import 'package:let_me_out/puzzle_state.dart';

class Tile {
  final int value;
  final GlobalKey key;
  final String? title;

  Offset origin = Offset.zero;
  Offset position = Offset.zero;
  Offset velocity = Offset.zero;

  bool hover = false;
  bool solved = false;

  Tile(this.value, this.key, {this.title});
}

extension TilePhysics on Tile {
  // update tile physics
  void update(double dt, GameState gameState) {
    if (gameState == GameState.solved) {
      if (solved) {
        _updateSolved(dt);
      }
    } else {
      _updateAttraction(dt, gameState);
    }
  }

  void _updateSolved(double dt) {
    if (dt < 0.0001) {
      return;
    }
    const gravity = Offset(0.0, 200.0);
    const dragCof = 0.001;
    final drag = velocity * -dragCof;
    velocity += gravity * dt;
    position += velocity * dt + gravity * (dt * dt * 0.5) + drag;
  }

  Offset _randomShakeVector() {
    final vel = Random().nextDouble() * (hover ? 420.0 : 96.0);
    final angle = Random().nextDouble() * 2 * pi;
    return Offset(cos(angle), sin(angle)) * vel;
  }

  bool _shouldShake(GameState gameState) {
    if (gameState == GameState.shuffle) {
      return false;
    }
    return Random().nextDouble() > (hover ? 0.93 : 0.97);
  }

  void _updateAttraction(double dt, GameState gameState) {
    Offset dir = origin - position;
    if (_shouldShake(gameState)) {
      dir += _randomShakeVector();
    }
    final dist = dir.distance;
    if (dist < 0.9 || dt < 0.0001) {
      return;
    }
    final dirNorm = dir / dist;
    final speed = 2.5 * dist;
    position += dirNorm * dt * speed;
  }
}
