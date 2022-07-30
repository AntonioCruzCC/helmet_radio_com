import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

import 'connection_handler.dart';

class MicHandler {
  ConnectionHandler connectionHandler;
  Stream<Uint8List>? stream;
  bool isRecording = false;
  Random rng = Random();
  late StreamSubscription listener;

  MicHandler(this.connectionHandler);

  _startListening() async {
    stream = await MicStream.microphone(
        audioSource: AudioSource.MIC,
        sampleRate: 16000,
        channelConfig: ChannelConfig.CHANNEL_IN_STEREO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT);

    listener =
        stream!.listen((data) => connectionHandler.handleDataToBeSent(data));
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
