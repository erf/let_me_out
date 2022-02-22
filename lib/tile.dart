import 'dart:math';

import 'package:flutter/material.dart';
import 'package:let_me_out/puzzle_state.dart';

class Tile {
  final int value;
  final GlobalKey key;

  Offset origin = Offset.zero;
  Offset target = Offset.zero;
  Offset position = Offset.zero;
  Offset velocity = Offset.zero;

  bool hover = false;
  bool solved = false;

  Tile(this.value, this.key);
}

extension TilePhysics on Tile {
  bool shouldShake(GameState gameState) {
    if (gameState == GameState.shuffle) {
      return false;
    }
    return Random().nextDouble() > (hover ? 0.93 : 0.97);
  }

  Offset randomShakeVector() {
    final vel = Random().nextDouble() * (hover ? 420.0 : 96.0);
    final angle = Random().nextDouble() * 2 * pi;
    return Offset(cos(angle), sin(angle)) * vel;
  }

  void update(double dt, GameState gameState) {
    Offset dir = target - position;
    if (shouldShake(gameState)) {
      dir += randomShakeVector();
    }
    final double dist = dir.distance;
    if (dist < 0.9 || dt < 0.0001) {
      return;
    }
    final dirNorm = dir / dist;
    final speed = 2.5 * dist;
    position += dirNorm * dt * speed;
  }

  void updateSolved(double dt) {
    if (dt < 0.0001) {
      return;
    }
    const Offset gravity = Offset(0.0, 200.0);
    const double dragCof = 0.001;
    final Offset drag = velocity * -dragCof;
    velocity += gravity * dt;
    position += velocity * dt + gravity * (dt * dt * 0.5) + drag;
  }
}
