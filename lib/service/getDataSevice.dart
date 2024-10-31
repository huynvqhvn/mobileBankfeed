import '../model/smsModel.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
class NativeDataChannel {
  // Tạo MethodChannel với tên duy nhất
  static const platform = MethodChannel('com.bankfeed.app/data');

  // Hàm gọi tới Native để lấy dữ liệu
  static Future<List<SmsModel>> getNativeData() async {
    try {
      // Gọi phương thức và nhận dữ liệu từ Android, ép kiểu về String nếu có thể
      String result = await platform.invokeMethod('getNativeData');
      List<dynamic> jsonList = json.decode(result);
      print("dynamic ${jsonList}");
      List<SmsModel> smsList =
          jsonList.map((item) => SmsModel.fromJson(item)).toList();
      print("smsList ${smsList}");
      return smsList;
    } catch (e) {
      print("Failed to get data from native: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  static Future<void> saveDataToPreferences(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getDataFromPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  static Future<void> checkAndSaveSerial() async {
  // Kiểm tra giá trị "Service ID" trong SharedPreferences
  String? serviceId = await NativeDataChannel.getDataFromPreferences("Service ID");

  if (serviceId == null || serviceId.isEmpty) {
    // Khởi tạo DeviceInfoPlugin để lấy serial
    final deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    String serviceID = androidInfo.id;
    // Lưu serial vào SharedPreferences
    await NativeDataChannel.saveDataToPreferences("Service ID", serviceID);
    print("Serial: $serviceID");
  }
}
}
