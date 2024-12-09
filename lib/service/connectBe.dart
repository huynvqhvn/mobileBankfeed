import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/bankList.dart';
import '../model/versionModel.dart';
import 'getDataSevice.dart';
import 'package:flutter/services.dart';

class ConnectToBe {
  static const platformVersion = MethodChannel('com.bankfeed.app/version');
  //Get data banks from api
  static Future<List<BankModel>> getBankModelList() async {
    final response =
        await http.get(Uri.parse("https://api.vietqr.io/v2/banks"));
    if (response.statusCode == 200) {
      print("Test 1 ${response.body}");
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> banksData = jsonResponse['data'];
      print("Test 1");
      final List<BankModel> bankList =
          banksData.map((item) => BankModel.fromJson(item)).toList();
      return bankList;
    } else {
      print("Failed to load rule");
      final List<BankModel> bankList = new List.empty();
      return bankList;
    }
  }

  // get data bank with short Name Bank
  static Future<BankModel?> getBankModelWithShortName(shortNameBank) async {
    final response =
        await http.get(Uri.parse("https://api.vietqr.io/v2/banks"));
    if (response.statusCode == 200) {
      print("Test 1 ${response.body}");
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> banksData = jsonResponse['data'];
      print("Test 1");
      final List<BankModel> bankList =
          banksData.map((item) => BankModel.fromJson(item)).toList();
      final BankModel bankResult =
          bankList.firstWhere((bank) => bank.shortName == shortNameBank);
      return bankResult;
    } else {
      print("Failed to load rule");
      return null; // Trả về null khi không thành công
    }
  }

  // kiểm tra version hiện có trên sever so sánh với version hiện tại trong database
  static Future<String> checkVersionSever() async {
    final response =
        await http.get(Uri.parse("https://id.staging.hvn.vn/versionApp.txt"));
    if (response.statusCode == 200) {
      print("response.body ${response.body}");
      String version = response.body;
      versionModel? versionCurrent = await NativeDataChannel.getVersion();
      if (version == versionCurrent!.version) {
        print("versionCurrent is same");
        return "same";
      } else {
        print("versionCurrent not same");
        return "notSame";
      }
      // return true;
    } else {
      print("Failed to load rule");
      return "error connect backend"; // Trả về null khi không thành công
    }
  }
}
