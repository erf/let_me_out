import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'tile.dart';

Soundpool soundPool = Soundpool.fromOptions(
  options: const SoundpoolOptions(maxStreams: 4),
);

Map<String, int> soundIdsMap = {};

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

  soundIdsMap = names.asMap().map((i, name) => MapEntry(name, soundIds[i]));
}
