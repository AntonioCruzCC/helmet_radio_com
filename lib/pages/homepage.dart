import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:helmet_radio_com/handlers/mic_handler.dart';
import 'package:helmet_radio_com/handlers/sound_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SoundHandler soundHandler = SoundHandler();
  late MicHandler micHandler = MicHandler(soundHandler);
  final info = NetworkInfo();

  handleCallControl() {
    soundHandler.toggle();
    micHandler.micToggle();
    setState(() {});
  }

  Future<String> getIp() async {
    return (await info.getWifiIP())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helmet Intercom'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleCallControl,
        child: micHandler.getIcon(),
      ),
      body: FutureBuilder(
        future: getIp(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: QrImage(
                      data: snapshot.requireData,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
