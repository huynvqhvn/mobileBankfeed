import '../model/smsModel.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../model/ruleModel.dart';
import 'package:flutter/material.dart';
import '../model/versionModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NativeDataChannel {
  // Tạo MethodChannel với tên duy nhất
  static const platform = MethodChannel('com.bankfeed.app/data');
  static const platformWebHook = MethodChannel('com.bankfeed.app/webhook');
  static const platformRule = MethodChannel('com.bankfeed.app/rule');
  static const platformVersion = MethodChannel('com.bankfeed.app/version');
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
    String? serviceId =
        await NativeDataChannel.getDataFromPreferences("Service ID");

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

  static Future<void> sendDataWebhookToNative(
      String input, BuildContext context) async {
    try {
      await platformWebHook.invokeMethod('userwebhook', {"input": input});
      print("Đã gửi input lên Android Native: $input");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thêm webhook thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Lỗi khi gửi dữ liệu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thêm webhook không thành công! ${e.toString()}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  static Future<String?> getDataWebhook() async {
    try {
      String result = await platformWebHook.invokeMethod('getuserwebhook');
      print("Dữ liệu nhận: $result");
      return result;
    } catch (e) {
      print("Lỗi không xác định khi nhận dữ liệu: $e");
      return null;
    }
  }

  static Future<bool> postRule(
      String rule, String typeRule, BuildContext context) async {
    print("rule name: ${rule}");
    if (rule != '') {
      try {
        await platformRule.invokeMethod('postRule', {
          "ruleIn": rule,
          "typeRule": typeRule,
        });

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm quy tắc thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Quay lại và trả về `true` để biểu thị thành công
        Navigator.pop(context, true);
        return true;
      } catch (e) {
        print("Lỗi khi gửi dữ liệu: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại!'),
            backgroundColor: Color(0xFFc93131),
          ),
        );

        // Trả về `false` để biểu thị thất bại
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không được để trống ngân hàng!'),
          backgroundColor: Color(0xFFc93131),
        ),
      );
      return false;
    }
  }

  static Future<List<Rule>> getRule() async {
    try {
      String jsonData = await platformRule.invokeMethod('getRule');
      print("jsonData2: $jsonData");
      List<dynamic> jsonList = json.decode(jsonData);
      print("jsonData2ab: $jsonData");
      List<Rule> smsList = jsonList.map((item) => Rule.fromJson(item)).toList();
      return smsList;
    } catch (e) {
      print("Lỗi khi gửi dữ liệuae2: $e");
      return [];
    }
  }

  static Future<bool> postStatusAsync(bool statusAsync) async {
    try {
      await platform.invokeMethod('getAsyncData', {'asyncData': statusAsync});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> getStatusAsync() async {
    try {
      bool statusAsync = await platform.invokeMethod('getAsyncDataFlutter');
      return statusAsync;
    } catch (e) {
      print("Lỗi không xác định khi nhận dữ liệu: $e");
      return false;
    }
  }

  static Future<bool> updateRuleDataBase(
      Rule ruleUpdate, BuildContext context) async {
    print("Log message");
    if (ruleUpdate.rulesName != '') {
      print("Log message23");
      try {
        await platformRule.invokeMethod("updateRule", {
          'id': ruleUpdate.typeId,
          'ruleName': ruleUpdate.rulesName,
          'ruleType': ruleUpdate.rulesType
        });

        print("Log message");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật quy tắc thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        print("Lỗi không xác định: ${Navigator.canPop(context)}");
        // Quay lại và trả về `true` để biểu thị thành công
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        }
        return true;
      } catch (e) {
        print("Lỗi không xác định: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại!'),
            backgroundColor: Color(0xFFc93131),
          ),
        );
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không được để trống ngân hàng'),
          backgroundColor: Color(0xFFc93131),
        ),
      );
      return false;
    }
  }

  static Future<bool> deleteRuleDataBase(
      int ruleId, BuildContext context) async {
    try {
      await platformRule.invokeMethod("deleteRule", {'ruleDelete': ruleId});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa quy tắc thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    } catch (e) {
      print("Lỗi không xác định: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi không xác định'),
          backgroundColor: Color(0xFFc93131),
        ),
      );
      return false;
    }
  }

/**
 * getAllRules() lấy hết các rule từ databases
 * &
 * Trả về danh sách các rule
 *  */
  static Future<List<Rule>> getAllRules() async {
    try {
      String jsonData = await platformRule.invokeMethod('getAllRules');
      print("jsonData2: $jsonData");
      List<dynamic> jsonList = json.decode(jsonData);
      print("jsonData2ab: $jsonData");
      List<Rule> smsList = jsonList.map((item) => Rule.fromJson(item)).toList();
      return smsList;
    } catch (e) {
      print("Lỗi khi gửi dữ liệuae2: $e");
      return [];
    }
  }

  static Future<versionModel?> getVersion() async {
    try {
      String jsonData = await platformVersion.invokeMethod('getVersion');

      // Parse JSON string thành Map
      Map<String, dynamic> parsedJson = json.decode(jsonData);
      versionModel chechVersion = versionModel.fromJson(parsedJson);
      return chechVersion;
    } catch (e) {
      print("Lỗi khi gửi dữ liệuae2: $e");
      return null;
    }
  }

  static Future<bool> updateVersion(
      int versionID, String vesion, String releaseNotes) async {
    try {
      await platformVersion.invokeMethod('updateVersion',
          {"id": versionID, "vesion": vesion, "releaseNotes": releaseNotes});
      return true;
    } catch (e) {
      print("Lỗi khi gửi dữ liệuae2: $e");
      return false;
    }
  }

  // Kiểm tra và yêu cầu quyền
  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

// Hàm kiểm tra và yêu cầu quyền
  static Future<bool> requestInstallPermission() async {
    var status = await Permission.requestInstallPackages.status;
    if (!status.isGranted) {
      // Nếu quyền chưa được cấp, yêu cầu quyền
      await Permission.requestInstallPackages.request();
    }
    return status.isGranted;
  }
}
