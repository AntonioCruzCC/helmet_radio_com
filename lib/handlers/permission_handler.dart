import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  requestPermissions() async {
    List<PermissionStatus> permissions = [];
    if (!await Permission.locationWhenInUse.isGranted) {
      permissions.add(await Permission.locationWhenInUse.request());
    }
    if (!await Permission.microphone.isGranted) {
      permissions.add(await Permission.microphone.request());
    }
  }
}
