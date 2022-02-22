import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'puzzle_state.dart';
import 'tile.dart';

class PhysicsGrid extends StatefulWidget {
  final PuzzleState puzzleState;

  const PhysicsGrid(
    this.puzzleState, {
    Key? key,
  }) : super(key: key);

  @override
  State<PhysicsGrid> createState() => _PhysicsGridState();
}

class _PhysicsGridState extends State<PhysicsGrid>
    with SingleTickerProviderStateMixin {
  List<Tile> tiles = [];
  double prevTime = 0.0;
  Size size = Size.zero;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(_init);
  }

  void _buildTilePositions() {
    tiles = [];
    final gridOffset = getGridOffset(context);
    for (Tile tile in widget.puzzleState.tiles) {
      tile.origin = getTileOffset(tile, gridOffset);
      tile.target = tile.origin;
      tiles.add(tile);
    }
  }

  // set the tile position at initialization
  void _init(Duration duration) {
    _buildTilePositions();

    setState(() {});

    createTicker(_update).start();
  }

  // get the grid offset relative to the grid parent
  Offset getGridOffset(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(Offset.zero);
  }

  // get the tile offset relative to the grid parent
  Offset getTileOffset(Tile tile, Offset gridOffset) {
    final RenderBox box =
        tile.key.currentContext?.findRenderObject() as RenderBox;
    final Size size = box.size;
    final Offset offset = box
        .localToGlobal(gridOffset)
        .translate(size.width / 2, size.height / 2);
    return offset;
  }

  bool sizeDidChange() {
    final Size newSize = MediaQuery.of(context).size;
    final didChange = size != newSize;
    size = newSize;
    return didChange;
  }

  void _update(Duration duration) {
    final gameState = widget.puzzleState.gameState;
    if (gameState == GameState.shuffled) {
      _buildTilePositions();
      puzzleStateNotifier.value = PuzzleState(tiles, GameState.playing);
    } else if (sizeDidChange()) {
      _buildTilePositions();
    }

    final double time = duration.inMilliseconds / 1000.0;
    final double dt = time - prevTime;
    prevTime = time;

    for (Tile tile in tiles) {
      if (gameState == GameState.solved) {
        if (tile.solved) {
          _updateSolvedPhysics(tile, dt);
        } else {
          _updateTilePhysics(tile, dt);
        }
      } else {
        _updateTilePhysics(tile, dt);
      }
    }

    setState(() {});
  }

  bool _shouldShake(Tile tile) {
    return Random().nextDouble() > (tile.hover ? 0.93 : 0.97);
  }

  void _updateSolvedPhysics(Tile tile, double dt) {
    if (dt > 0.0001) {
      const Offset gravity = Offset(0.0, 200.0);
      const double dragCof = 0.001;
      final Offset drag = tile.velocity * -dragCof;
      tile.velocity += gravity * dt;
      tile.position += tile.velocity * dt + gravity * (dt * dt * 0.5) + drag;
    }
  }

  Offset getRandomShakeVector(Tile tile) {
    final vel = Random().nextDouble() * (tile.hover ? 420.0 : 64.0);
    final angle = Random().nextDouble() * 2 * pi;
    return Offset(cos(angle), sin(angle)) * vel;
  }

  void _updateTilePhysics(Tile tile, double dt) {
    Offset dir = tile.target - tile.position;
    if (_shouldShake(tile)) {
      dir += getRandomShakeVector(tile);
    }
    double dist = dir.distance;
    if (dist > 0.9 && dt > 0.0001) {
      final dirNorm = dir / dist;
      final speed = 2.5 * dist;
      tile.position += dirNorm * dt * speed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TilesPainter(tiles),
    );
  }
}

class TilesPainter extends CustomPainter {
  final List<Tile> tiles;

  final brush = Paint()
    ..color = const Color.fromARGB(255, 235, 92, 223).withAlpha(72);

  TilesPainter(this.tiles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final Tile tile in tiles) {
      if (tile.value == -1) {
        continue;
      }
      if (tile.hover || tile.solved) {
        canvas.drawCircle(tile.position, 24, brush);
      } else {
        canvas.drawCircle(tile.position, 16, brush);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
