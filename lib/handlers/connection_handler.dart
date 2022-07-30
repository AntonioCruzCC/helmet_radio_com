import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:helmet_radio_com/handlers/mic_handler.dart';
import 'package:helmet_radio_com/handlers/sound_handler.dart';
import 'package:helmet_radio_com/pages/call_page.dart';
import 'package:helmet_radio_com/pages/homepage.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectionHandler {
  static final ConnectionHandler _instance = ConnectionHandler._internal();
  SoundHandler soundHandler = SoundHandler();
  late String myIp;
  String? sendIp;
  late RawDatagramSocket socket;
  late RawDatagramSocket callSocket;
  late MicHandler micHandler;
  final info = NetworkInfo();
  final int port = 1234;
  bool onCall = false;

  Future<String> getIp() async {
    String? ip = await info.getWifiIP();
    ip ??= InternetAddress.anyIPv4.address;
    return ip;
  }

  startServer() async {
    myIp = await getIp();
    socket = await RawDatagramSocket.bind(myIp, port);
    socket.listen((event) => {handleRawCommunication(event)});
  }

  connect(String sendIp) async {
    this.sendIp = sendIp;
    handleRawCommunication(null);
  }

  endCall() {
    if (onCall) {
      micHandler.micToggle();
      soundHandler.toggle();
      socket.send([], InternetAddress(sendIp!), port);
    }
    Get.to(() => const HomePage());
    onCall = false;
  }

  handleRawCommunication(RawSocketEvent? event) {
    if (event == null || event == RawSocketEvent.read) {
      if (event != null) {
        Datagram? dg = socket.receive();
        if (dg == null) {
          if (onCall) {
            endCall();
            return;
          }
        } else if (dg.data.every((element) => element == 1)) {
          Get.to(() => CallPage(this));
        }
        sendIp = dg?.address.address;
        handleReceivedData(dg!.data);
      } else {
        socket.send([1], InternetAddress(sendIp!), port);
        Get.to(() => CallPage(this));
      }

      onCall = true;
    }
  }

  toggleMicAndSound() {
    micHandler = MicHandler(this);
    micHandler.micToggle();
    soundHandler.toggle();
  }

  handleReceivedData(Uint8List data) {
    soundHandler.feed(data);
  }

  handleDataToBeSent(Uint8List data) {
    if (sendIp != null) {
      socket.send(data, InternetAddress(sendIp!), port);
    }
  }

  factory ConnectionHandler() {
    return _instance;
  }
  ConnectionHandler._internal() {
    startServer();
  }
}
