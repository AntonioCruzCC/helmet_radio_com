import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  requestPermissions() async {
    if (!await Permission.locationWhenInUse.isGranted) {
      await Permission.locationWhenInUse.request();
    }
    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
    }
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }
}
