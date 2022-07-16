import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helmet_radio_com/handlers/mic_handler.dart';
import 'package:helmet_radio_com/handlers/sound_handler.dart';
import 'package:helmet_radio_com/pages/call_page.dart';
import 'package:helmet_radio_com/pages/homepage.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectionHandler {
  SoundHandler soundHandler = SoundHandler();
  late ServerSocket server;
  late Socket calllSocket;
  late MicHandler micHandler;
  final info = NetworkInfo();

  ConnectionHandler() {
    startServer();
  }

  Future<String> getIp() async {
    return (await info.getWifiIP())!;
  }

  startServer() async {
    server = await ServerSocket.bind(await getIp(), 8080);
    server.listen((client) => {handleCommunication(client)});
  }

  connect(BuildContext context, String ip) async {
    calllSocket = await Socket.connect(ip, 8080);
    handleCommunication(calllSocket);
  }

  endCall() {
    micHandler.micToggle();
    soundHandler.toggle();
    calllSocket.close();
    Get.to(const HomePage());
  }

  handleCommunication(Socket socket) {
    calllSocket = socket;
    micHandler = MicHandler(socket);
    micHandler.micToggle();
    soundHandler.toggle();
    socket.listen((data) {
      soundHandler.feed(data);
    }, onDone: () => endCall());
    Get.to(() => CallPage(this));
  }
}
