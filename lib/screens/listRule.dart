import 'package:bank_feed_vs1/model/smsModel.dart';
import 'package:flutter/material.dart';
import '../model/ruleModel.dart';
import '../service/connectBe.dart';
import "../service/getDataSevice.dart";
import 'package:page_transition/page_transition.dart';
import 'addRule.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "managerRule.dart";
class ListRule extends StatefulWidget {
  const ListRule({super.key});
  @override
  State<ListRule> createState() => _ListRuleState();
}

class _ListRuleState extends State<ListRule> {
  late List<Rule> listRule = [];
  late List<SmsModel> listSms = [];
  late String? useWeebHook = "";
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
    await Future.delayed(Duration(seconds: 3));
    try {
      listSms = await NativeDataChannel.getNativeData();
      // listRuleSms = await connectToBe.fetchRule();
      useWeebHook = await NativeDataChannel.getDataWebhook();
      listRule = await NativeDataChannel.getRule();
      print("listRuleSms: $listRule");
      print("listSms: ${listSms.length}");
      print("useWeebHook: ${useWeebHook}");
      // Kiểm tra xem danh sách có rỗng không
      if (listRule.isNotEmpty) {
        if (mounted) {
          setState(() {
            statusScreen =
                true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
          });
        }
      }
      else {
        setState(() {
            statusScreen =
                true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
          });
      }
    } catch (e) {
      print("Có lỗi xảy ra: $e");
    }
  }

  Future<void> checkWeebhook() async {
    String userWebhookInput = Webhook.text.trim();
    RegExp regex = RegExp(
        r'^https:\/\/id\.staging\.hvn\.vn\/index\.php\?m=bankfeeds&id=[a-f0-9\-]+&action=receive-sms$');
    if (regex.hasMatch(userWebhookInput)) {
      print("checkWeebhook match");
      await NativeDataChannel.sendDataWebhookToNative(userWebhookInput);
    } else {
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
          child: !statusScreen
              ? Align(
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: Colors.red,
                    rightDotColor: Colors.blue,
                    size: 50,
                  ),
                )
              : Column(
                  // Sử dụng Column để chứa nhiều Row
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Căn chỉnh từ trên xuống
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
                                    textAlign:
                                        TextAlign.center, // Căn giữa văn bản
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    controller: Webhook,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Nhập webhook của bạn ở đây',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
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

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Row(
                        children: [
                          Text(
                            "Các Quy Tắc",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  alignment: Alignment.topCenter,
                                  child: ManagerRule(),
                                ),
                              );
                            },
                            child: Text(
                              "Xem Tất Cả",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ]),
                    SizedBox(height: 15),

                    Expanded(
                      child: ListView.builder(
                        itemCount: listRule.length,
                        itemBuilder: (context, index) {
                          final item = listRule[index];
                          return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Quy tắc: ",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight:
                                                  FontWeight.bold), // Sửa ở đây
                                        ),
                                        Text(item.rulesName),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          "Loại quy tắc:  ",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.rulesType,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
