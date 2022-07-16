import 'package:flutter/material.dart';
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
  ConnectionHandler connectionHandler = ConnectionHandler();

  @override
  void initState() {
    permissionHandler.requestPermissions();
    super.initState();
  }

  openQRCodePage() async {
    final qrCode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const QRCodePage(),
      ),
    );
    connectionHandler.connect(context, qrCode.code);
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CallPage(connectionHandler),
      ),
    );
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
