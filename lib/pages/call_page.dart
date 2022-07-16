import 'package:flutter/material.dart';
import 'package:helmet_radio_com/handlers/connection_handler.dart';

// ignore: must_be_immutable
class CallPage extends StatefulWidget {
  ConnectionHandler connectionHandler;
  CallPage(this.connectionHandler, {Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('EM CHAMADA!'),
            ElevatedButton(
              onPressed: (() => widget.connectionHandler.endCall()),
              child: const Text('FINALIZAR!'),
            )
          ],
        ),
      ),
    );
  }
}
