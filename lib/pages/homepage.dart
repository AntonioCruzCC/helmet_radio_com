import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:helmet_radio_com/handlers/connection_handler.dart';
import 'package:helmet_radio_com/handlers/permission_handler.dart';
import 'package:helmet_radio_com/pages/call_page.dart';
import 'package:helmet_radio_com/pages/qr_code_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PermissionHandler permissionHandler = PermissionHandler();
  late ConnectionHandler connectionHandler;

  @override
  void initState() {
    permissionHandler.requestPermissions();
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText:
          "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    FlutterBackground.initialize(androidConfig: androidConfig)
        .then((value) => print(value));
    connectionHandler = ConnectionHandler();
    super.initState();
  }

  openQRCodePage() async {
    final qrCode = await Get.to(() => const QRCodePage());
    if (!qrCode.code.isEmpty) {
      connectionHandler.connect(qrCode.code);
      Get.lazyReplace(() => CallPage(connectionHandler));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helmet Intercom'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openQRCodePage,
        child: const Icon(Icons.camera_alt),
      ),
      body: FutureBuilder(
        future: connectionHandler.getIp(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.requireData == '') {
              return const Center(
                child: Text('Permissão de localização necessária.'),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'Leia o QR Code abaixo com outro smartphone para iniciar a chamada.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
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
