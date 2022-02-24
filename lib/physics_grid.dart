import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'puzzle_state.dart';
import 'tile.dart';

/// A set of particles that are attracted to the buttons in the grid.
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
  Duration prevTime = Duration.zero;
  Size size = Size.zero;
  late PuzzleState puzzleState;
  late Ticker ticker;

  @override
  void initState() {
    super.initState();

    // set initial state
    puzzleState = widget.puzzleState;

    // init tiles after first frame
    WidgetsBinding.instance?.addPostFrameCallback(init);

    // listen to state changes
    puzzleStateNotifier.addListener(() {
      puzzleState = puzzleStateNotifier.value;
      if (puzzleState.gameState == GameState.shuffle) {
        setTilePositions();
      }
      setState(() {});
    });
  }

  // dispose of the ticker
  @override
  void dispose() {
    ticker.dispose();

    super.dispose();
  }

  // set the tile position at initialization and start the update ticker
  void init(Duration duration) {
    setTilePositions();
    setState(() {});
    ticker = createTicker(_update)..start();
  }

  /// Set the tile positions.
  void setTilePositions() {
    final gridOffset = getGridOffset(context);
    for (Tile tile in puzzleState.tiles) {
      tile.origin = getTileOffset(tile, gridOffset);
      tile.target = tile.origin;
    }
  }

  /// Get the grid offset relative to the grid parent.
  Offset getGridOffset(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(Offset.zero);
  }

  /// Get the tile offset relative to the grid parent.
  Offset getTileOffset(Tile tile, Offset gridOffset) {
    final BuildContext? buildContext = tile.key.currentContext;
    if (buildContext == null) {
      return Offset.zero;
    }
    final RenderBox box = buildContext.findRenderObject() as RenderBox;
    final Size size = box.size;
    final Offset offset = box
        .localToGlobal(gridOffset)
        .translate(size.width / 2, size.height / 2);
    return offset;
  }

  // check if the window size has changed
  bool sizeDidChange() {
    final Size newSize = MediaQuery.of(context).size;
    final didChange = size != newSize;
    size = newSize;
    return didChange;
  }

  /// Update tile positions and render.
  void _update(Duration duration) {
    // update position of tiles if the size changed
    if (sizeDidChange()) {
      setTilePositions();
    }

    // get the time since the last update
    final Duration delta = duration - prevTime;
    prevTime = duration;
    final double dt = delta.inMicroseconds / 1e6;

    // update tile physics
    for (Tile tile in puzzleState.tiles) {
      tile.update(dt, puzzleState.gameState);
    }

    // render points with new positions
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TilesPainter(puzzleState.tiles),
    );
  }
}

/// Paint the tile particles as circles.
class TilesPainter extends CustomPainter {
  final List<Tile> tiles;

  static final brush = Paint()..color = const Color(0x48eb5cdf);

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
