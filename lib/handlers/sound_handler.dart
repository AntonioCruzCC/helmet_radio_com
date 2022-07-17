import 'dart:typed_data';

import 'package:raw_sound/raw_sound_player.dart';

class SoundHandler {
  final player = RawSoundPlayer();
  bool isPlaying = false;

  SoundHandler() {
    player.initialize(
      bufferSize: 1024,
      nChannels: 2,
      sampleRate: 16000,
      pcmType: RawSoundPCMType.PCMI16,
    );
  }

  toggle() {
    isPlaying ? _stop() : _play();
    isPlaying = !isPlaying;
  }

  _play() async {
    await player.play();
  }

  _stop() async {
    await player.stop();
  }

  feed(Uint8List data) {
    player.feed(data);
  }
}
