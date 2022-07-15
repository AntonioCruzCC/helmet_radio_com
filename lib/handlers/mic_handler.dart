import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:helmet_radio_com/handlers/sound_handler.dart';
import 'package:mic_stream/mic_stream.dart';

class MicHandler {
  Stream<Uint8List>? stream;
  bool isRecording = false;
  Random rng = Random();
  late StreamSubscription listener;
  SoundHandler soundHandler;

  MicHandler(this.soundHandler);

  startListening() async {
    MicStream.shouldRequestPermission(true);

    stream = await MicStream.microphone(
        audioSource: AudioSource.MIC,
        sampleRate: 16000,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT);

    listener = stream!.listen((data) => {soundHandler.feed(data)});
  }

  stopListening() {
    listener.cancel();
  }

  micToggle() {
    isRecording ? stopListening() : startListening();
    isRecording = !isRecording;
  }

  Widget getIcon() {
    return Icon(isRecording ? Icons.mic : Icons.mic_off);
  }
}
