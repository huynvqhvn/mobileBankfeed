import 'package:bank_feed_vs1/model/smsModel.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Component/titleSection.dart';
import '../model/ruleModel.dart';
import '../service/connectBe.dart';
import '../model/ruleList.dart';
import "../service/getDataSevice.dart";

class ListRule extends StatefulWidget {
  const ListRule({super.key});
  @override
  State<ListRule> createState() => _ListRuleState();
}

class _ListRuleState extends State<ListRule> {
  late List<Rule> listRuleSms = [];
  late List<SmsModel> listSms = [];
  final ConnectToBe connectToBe = ConnectToBe(); // Khởi tạo instance
  late final TextEditingController Webhook;
  bool statusScreen = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    Webhook = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    Webhook.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    try {
      listSms = await NativeDataChannel.getNativeData();
      listRuleSms = await connectToBe.fetchRule();
      print("listRuleSms: $listRuleSms");
      print("listSms: ${listSms.length}");
      // Kiểm tra xem danh sách có rỗng không
      if (listRuleSms.isNotEmpty) {
        if (mounted) {
          setState(() {
            statusScreen =
                true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
          });
        }
      }
    } catch (e) {
      print("Có lỗi xảy ra: $e");
    }
  }

  Future<void> checkWeebhook() async {
    String userWebhookInput = Webhook.text.trim();
    RegExp regex = RegExp(r'^https:\/\/id\.staging\.hvn\.vn\/index\.php\?m=bankfeeds&id=[a-f0-9\-]+&action=receive-sms$');
    if(regex.hasMatch(userWebhookInput)){
      print("checkWeebhook match");
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Webhook không đúng định dạng'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Feed"),
        centerTitle: true,
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Sử dụng Column để chứa nhiều Row
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Căn chỉnh từ trên xuống
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Đề các thiết bị của bạn phản ứng, với các thay đổi về điều kiện.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30), // Khoảng cách giữa các Row
              Row(
                children: [
                  Expanded(
                    // Đặt Expanded ở đây để lấp đầy không gian
                    child: Container(
                      color: Colors.white,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.mobile_screen_share_outlined,
                              color: Colors.red,
                              size: 60,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Nhập Webhook của bạn ở đây",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              textAlign: TextAlign.center, // Căn giữa văn bản
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: Webhook,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Nhập webhook của bạn ở đây',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  checkWeebhook();
                                },
                                child: const Text(
                                  'Kiểm tra',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16), // Kiểu chữ
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Bán kính góc
                                  ),
                                  backgroundColor: Colors.red, // Màu nền
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Các Quy Tắc",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Button Add được bấm");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
