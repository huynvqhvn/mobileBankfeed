import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/accountModel.dart';
import '../model/ruleModel.dart';
import '../model/ruleList.dart';
import '../model/smsModel.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ConnectToBe {
  final String ulr = "https://227b-113-190-253-89.ngrok-free.app";
  Future<List<Account>> fetchAccount() async {
    final response = await http
        .get(Uri.parse('${ulr}/account'));

    if (response.statusCode == 200) {
      // Phân tích cú pháp JSON và tạo danh sách Account
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Account> accounts = jsonData.map((item) => Account.fromJson(item)).toList();
      accounts.forEach((account) => {print('${account.email}')});
      return accounts; // Trả về danh sách tài khoản
    } else {
      print("Failed to load accounts");
      final List<Account> accounts = new List.empty();
      return accounts;
    }
  }

  Future<List<Rule>> fetchRule() async {
    final response = await http
        .get(Uri.parse('${ulr}/smsRule'));
    if (response.statusCode == 200) {
      // Phân tích cú pháp JSON và tạo danh sách Account
      final List<dynamic> jsonData = jsonDecode(response.body);
      print("Test 1");
      final List<Rule> rules =
          jsonData.map((item) => Rule.fromJson(item)).toList();
      print("Test 1");
      rules.forEach((rule) => {print('${rule.keySearch}' + "smsRule")});
      return rules; // Trả về danh sách tài khoản
    } else {
      print("Failed to load rule");
      final List<Rule> rules = new List.empty();
      return rules;
    }
  }

  Future<http.Response> sendSmsToServer(
      SmsModel smsModel) async {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final response = await http.post(
      Uri.parse('${ulr}/dataTransition'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": "${smsModel.id}",
        "sender": smsModel.author,
        "message": smsModel.message,
        "timestamp": smsModel.timestamp,
        "serial_number": androidInfo.model,
      }),
    );
    return response;
  }

static  Future<http.Response> sendLogToServer(
      String logcat) async {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final response = await http.post(
      Uri.parse('https://227b-113-190-253-89.ngrok-free.app/log'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "log": "${logcat}"
      }),
    );
    return response;
  }
}
