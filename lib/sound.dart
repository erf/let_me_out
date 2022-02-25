import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'tile.dart';

/// Sound manager
class Sound {
  static final Sound instance = Sound._();

  final _soundPool = Soundpool.fromOptions(
    options: const SoundpoolOptions(maxStreams: 4),
  );

  Map<String, int> _soundIdMap = {};

  Sound._();

  Future<void> load() async {
    final names = List.generate(16, (i) => getSoundName(i));

    final soundIdFutures = names
        .map((name) => rootBundle.load(name))
        .map((future) => future.then((bytes) => _soundPool.load(bytes)));

    final soundIds = await Future.wait(soundIdFutures);

    _soundIdMap = names.asMap().map((i, name) => MapEntry(name, soundIds[i]));
  }

  String getSoundName(int value) {
    return 'assets/sounds/sound_$value.mp3';
  }

  int getSoundId(Tile tile) {
    return _soundIdMap[getSoundName(tile.value)]!;
  }

  Future<int> play(Tile tile) async {
    return await _soundPool.play(getSoundId(tile));
  }
}
