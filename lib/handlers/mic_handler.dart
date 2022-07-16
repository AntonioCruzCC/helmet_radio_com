import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

class MicHandler {
  Stream<Uint8List>? stream;
  bool isRecording = false;
  Random rng = Random();
  late StreamSubscription listener;
  Socket socket;

  MicHandler(this.socket);

  _startListening() async {
    stream = await MicStream.microphone(
        audioSource: AudioSource.MIC,
        sampleRate: 16000,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT);

    listener = stream!.listen((data) {
      socket.add(data);
    });
  }

  _stopListening() async {
    await listener.cancel();
  }

  micToggle() {
    isRecording ? _stopListening() : _startListening();
    isRecording = !isRecording;
  }

  Widget getIcon() {
    return Icon(isRecording ? Icons.mic : Icons.mic_off);
  }
}
