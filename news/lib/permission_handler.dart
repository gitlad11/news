import 'package:permission_handler/permission_handler.dart';

storagePermission(callback) async {
  if (await Permission.storage.request().isGranted) {
    callback();
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
    return;
  }
}