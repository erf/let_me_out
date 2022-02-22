import 'package:flutter/material.dart';

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
  Duration previousFrameTime = Duration.zero;
  Size size = Size.zero;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(init);
  }

  void initTilePositions() {
    tiles = [];
    final gridOffset = getGridOffset(context);
    for (Tile tile in widget.puzzleState.tiles) {
      tile.origin = getTileOffset(tile, gridOffset);
      tile.target = tile.origin;
      tiles.add(tile);
    }
  }

  // set the tile position at initialization
  void init(Duration duration) {
    initTilePositions();
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
    final BuildContext? buildContext = tile.key.currentContext;
    if (buildContext == null) {
      debugPrint('BuildContext for tile ${tile.value} is null');
      return Offset.zero;
    }
    final RenderBox box = buildContext.findRenderObject() as RenderBox;
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
      initTilePositions();
      puzzleStateNotifier.value = PuzzleState(tiles, GameState.playing);
    } else if (sizeDidChange()) {
      initTilePositions();
    }

    final Duration delta = duration - previousFrameTime;
    previousFrameTime = duration;
    final double dt = delta.inMicroseconds / 1e6;

    // update tile positions
    for (Tile tile in tiles) {
      if (gameState == GameState.solved && tile.solved) {
        tile.updateSolved(dt);
      } else {
        tile.update(dt);
      }
    }

    setState(() {});
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
