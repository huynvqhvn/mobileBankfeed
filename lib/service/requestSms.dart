
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../database/smsDatabase.dart';
import '../model/smsModel.dart';
import 'connectBe.dart';


class PermissionService {
  Timer? _timer;

  Future<void> startSync() async {
    // Khởi động Timer để thực hiện syncData mỗi 10 giây
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      syncData();
    });
  }

  Future<void> syncData() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        // .addMigrations([createTableMigration])
        .build();
    final smsDao = database.smsDao;

    List<SmsModel> allSms = await smsDao.findAllSms();
    ConnectToBe connectToBe = ConnectToBe();

    for (var element in allSms) {
      // Thay forEach bằng vòng lặp for
      if (element.isSendMessage == false) {
        try {
          print("Element ${element.isSendMessage}");

          var response =
              await connectToBe.sendSmsToServer(element); // Sử dụng await
          if (response.statusCode == 201) {
            element.isSendMessage = true;
            await smsDao.updateSms(element);
          }
        } catch (e) {
          print("Error: $e");
        }
      }
    }

    print("startSync ${allSms.length}");
  }

  Future<void> stopSync() async {
    // Dừng Timer khi không cần thiết
    _timer?.cancel();
  }

  Future<bool> checkSmsPermission() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      // Yêu cầu quyền
      var status = await Permission.sms.request().isGranted;
      if (status) {
        return true; // Quyền đã được cấp
      } else {
        SystemNavigator.pop();
        return false; // Quyền bị từ chối
      }
    }
    return true; // Quyền đã được cấp
  }

  Future<bool> checkNotificationPermission() async {
    // Kiểm tra trạng thái quyền thông báo
    var status = await Permission.notification.status;

    if (!status.isGranted) {
      // Nếu quyền chưa được cấp, yêu cầu quyền
      var requestStatus = await Permission.notification.request();
      if (requestStatus.isGranted) {
        return true; // Quyền đã được cấp sau khi yêu cầu
      } else {
        // Quyền bị từ chối sau khi yêu cầu, thoát ứng dụng (tùy theo nhu cầu)
        SystemNavigator.pop();
        return false;
      }
    }

    // Nếu quyền đã được cấp sẵn, trả về true
    return true;
  }

  @pragma(
      'vm:entry-point') // Prevent Dart from stripping out this function in release builds
  Future<void> getSms(bool status) async {
    print("status: hello");
    const platform = MethodChannel('com.receiver/sms');
    final database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        // .addMigrations([createTableMigration])
        .build();

    final smsDao = database.smsDao;
    print("getLastSms: ${await smsDao.getLastSms()}");
    print("status: ${status}");
    platform.setMethodCallHandler((call) async {
      if (status == true) {
        print("call ${call.runtimeType}");
        if (call.method == "onSmsReceived") {
          Map messageIn = call.arguments;
          try {
            int lastSmsId = (await smsDao.getLastSms()) ?? 0;
            print("getLastSms: ${await smsDao.getLastSms()}");
            lastSmsId += 1;
            if (messageIn['sender'].runtimeType != null &&
                messageIn['message'].runtimeType != null &&
                messageIn['timestamp'].runtimeType != null) {
              final sms = SmsModel(
                id: lastSmsId,
                author: messageIn['sender'],
                message: messageIn['message'],
                timestamp: messageIn['timestamp'],
                isSendMessage: false,
              );

              // Chèn SMS vào cơ sở dữ liệu
              await smsDao.insertSms(sms);
              List<SmsModel> allSms = await smsDao.findAllSms();
              // for (SmsModel sms in allSms) {
              //   print(
              //       "sms: ${sms.author} ${sms.id} ${sms.message} ${sms.timestamp} ${sms.isSendMessage}");
              // }
            }
          } catch (e) {
            print("Error while handling SMSjiju: $e");
          }
        }
      }
    });
  }
}
