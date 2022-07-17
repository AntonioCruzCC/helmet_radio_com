import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helmet_radio_com/handlers/mic_handler.dart';
import 'package:helmet_radio_com/handlers/sound_handler.dart';
import 'package:helmet_radio_com/pages/call_page.dart';
import 'package:helmet_radio_com/pages/homepage.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectionHandler {
  static final ConnectionHandler _instance = ConnectionHandler._internal();
  SoundHandler soundHandler = SoundHandler();
  late ServerSocket server;
  late Socket calllSocket;
  late MicHandler micHandler;
  final info = NetworkInfo();
  bool onCall = false;

  Future<String> getIp() async {
    return (await info.getWifiIP())!;
  }

  startServer() async {
    server = await ServerSocket.bind(await getIp(), 8080);
    server.listen((client) => {handleCommunication(client)});
  }

  connect(BuildContext context, String ip) async {
    calllSocket = await Socket.connect(ip, 8080).onError(
      (error, stackTrace) => endCall(),
    );
    handleCommunication(calllSocket);
  }

  endCall() {
    if (onCall) {
      micHandler.micToggle();
      soundHandler.toggle();
      calllSocket.close();
    }
    Get.lazyReplace(() => const HomePage());
    onCall = false;
  }

  handleCommunication(Socket socket) {
    onCall = true;
    calllSocket = socket;
    micHandler = MicHandler(socket, this);
    micHandler.micToggle();
    soundHandler.toggle();
    socket.listen((data) {
      soundHandler.feed(data);
    }, onDone: () => endCall());
    Get.lazyReplace(() => CallPage(this));
  }

  factory ConnectionHandler() {
    return _instance;
  }
  ConnectionHandler._internal() {
    startServer();
  }
}
