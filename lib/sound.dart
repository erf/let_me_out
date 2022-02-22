import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'tile.dart';

Soundpool soundPool = Soundpool.fromOptions(
  options: const SoundpoolOptions(maxStreams: 4),
);

final soundIdsMap = <String, int>{};

String getSoundName(int tileValue) {
  return 'assets/sounds/sound_$tileValue.mp3';
}

int getSoundId(Tile tile) {
  return soundIdsMap[getSoundName(tile.value)]!;
}

Future<void> initSounds() async {
  final names = List.generate(15, (i) => getSoundName(i));

  final soundIdFutures = names
      .map((name) => rootBundle.load(name))
      .map((future) => future.then((bytes) => soundPool.load(bytes)));

  final soundIds = await Future.wait(soundIdFutures);

  soundIdsMap
      .addAll(names.asMap().map((i, name) => MapEntry(name, soundIds[i])));
}
