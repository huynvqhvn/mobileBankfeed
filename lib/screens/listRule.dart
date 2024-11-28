import 'package:bank_feed_vs1/model/smsModel.dart';
import 'package:flutter/material.dart';
import '../model/ruleModel.dart';
import '../service/connectBe.dart';
import "../service/getDataSevice.dart";
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'addRule.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "managerRule.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

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
  late String? idService = "";
  bool statusScreen = false;
  final List<String> guideSteps = [
    "Bước 1: Mở ứng dụng.",
    "Bước 2: Đăng nhập vào trang https://id.hvn.vn/",
    "Bước 3: Vào Dashboard kéo xuống dưới và sao chép đường dẫn Webhooks (không chia sẻ cho bất kì ai khác)",
    "Bước 4: Copy link webhooks của bạn",
    "Bước 5: Trở về app BankFeeds và điền webhooks",
    "Bước 6: Tạo các quy tắc nhận tin nhắn của bạn ở trên trang https://id.hvn.vn/",
    "Bước 7: Tạo các quy tắc tương tự trên trang https://id.hvn.vn/ trên app điện thoại",
  ];
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
    await Future.delayed(Duration(seconds: 2));
    try {
      listSms = await NativeDataChannel.getNativeData();
      // listRuleSms = await connectToBe.fetchRule();
      useWeebHook = await NativeDataChannel.getDataWebhook();
      listRule = await NativeDataChannel.getRule();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      idService = prefs.getString('Service ID');
      // Kiểm tra xem danh sách có rỗng không
      if (listRule.isNotEmpty) {
        if (mounted) {
          setState(() {
            statusScreen =
                true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
          });
        }
      } else {
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
        r'^https:\/\/iddev\.hvn\.vn\/index\.php\?m=bankfeeds&id=[a-f0-9\-]+&action=[a-z\-]+$');
    if (regex.hasMatch(userWebhookInput)) {
      print("checkWeebhook match");
      await NativeDataChannel.sendDataWebhookToNative(
          userWebhookInput, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Webhook không đúng định dạng'),
        ),
      );
    }
  }

  Future<void> _copyAndSave(BuildContext context) async {
    // Sao chép dữ liệu vào clipboard
    await Clipboard.setData(ClipboardData(text: idService!));

    // Lưu dữ liệu vào bộ nhớ tạm
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/clipboard_data.txt');
    await file.writeAsString(idService!);

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép: $idService'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Hàm mở URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Feed"),
        centerTitle: true,
        backgroundColor: Color(0xFFc93131),
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
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Color(0xFFc93131),
                    size: 50,
                  ),
                )
              : Column(
                  // Sử dụng Column để chứa nhiều Row
                  children: [
                    Row(children: [
                      Text(
                        "Serial thiết bị : ",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFc93131),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center, // Căn giữa văn bản
                      ),
                      Text(
                        idService!,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center, // Căn giữa văn bản
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _copyAndSave(context);
                        },
                        child: Icon(Icons.copy, size: 20),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(5, 35),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Bán kính góc
                          ),
                          backgroundColor: Colors.white, // Màu nền
                        ),
                      )
                    ]),
                    SizedBox(height: 20), // Khoảng cách giữa các Row
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
                                    color: Color(0xFFc93131),
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
                                      hintText: useWeebHook != null
                                          ? useWeebHook
                                          : 'Nhập webhook của bạn ở đây',
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
                                        backgroundColor:
                                            Color(0xFFc93131), // Màu nền
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
                            "Hướng Dẫn Sử Dụng",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ]),
                    SizedBox(height: 15),
                    Container(
                      height: 200, // Chiều cao cụ thể cho ListView
                      child: ListView.builder(
                        itemCount: guideSteps.length,
                        itemBuilder: (context, index) {
                          final step = guideSteps[index];

                          // Tìm link trong chuỗi
                          final RegExp linkRegex = RegExp(r'https?:\/\/[^\s]+');
                          final match = linkRegex.firstMatch(step);
                          if (match != null) {
                            final link = match.group(0); // Lấy URL từ chuỗi
                            final parts =
                                step.split(link!); // Chia chuỗi theo link
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: parts[0], // Phần trước URL
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () => _launchURL(link),
                                        child: Text(
                                          link,
                                          style: TextStyle(
                                            color: Color(0xFFc93131),
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (parts.length > 1)
                                      TextSpan(
                                        text: parts[1], // Phần sau URL
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Không có URL
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                step,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            );
                          }
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
