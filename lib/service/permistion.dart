import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class NotificationAccessHelper {
  static const platform = MethodChannel('com.example.yourapp/notifications');

  static Future<void> openNotificationAccessSettings() async {
    try {
      await platform.invokeMethod('openNotificationAccessSettings');
    } on PlatformException catch (e) {
      print("Failed to open notification access settings: '${e.message}'.");
    }
  }

  static Future<void> requestSmsPermission() async {
    var status = await Permission.sms.status;

    if (!status.isGranted) {
      // Yêu cầu quyền
      status = await Permission.sms.request();

      if (status.isGranted) {
        print('Quyền đọc SMS đã được cấp');
      } else {
        print('Quyền đọc SMS bị từ chối');
      }
    }
  }
}
