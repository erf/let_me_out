import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'tile.dart';

Soundpool soundPool = Soundpool.fromOptions(
  options: const SoundpoolOptions(maxStreams: 4),
);

final soundsIds = <String, int>{};

Future<void> initSounds() async {
  final names = List.generate(15, (i) => "assets/sounds/sound_$i.mp3");

  final soundIdFutures = names
      .map((name) => rootBundle.load(name))
      .map((future) => future.then((bytes) => soundPool.load(bytes)));

  final soundIds = await Future.wait(soundIdFutures);

  soundsIds.addAll(names.asMap().map((i, name) => MapEntry(name, soundIds[i])));
}

String getSoundName(Tile tile) {
  return 'assets/sounds/sound_${tile.value}.mp3';
}

int getSoundId(Tile tile) {
  return soundsIds[getSoundName(tile)]!;
}
