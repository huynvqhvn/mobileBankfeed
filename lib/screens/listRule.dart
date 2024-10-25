import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Component/titleSection.dart';
import '../model/ruleModel.dart';
import '../service/connectBe.dart';
import '../model/ruleList.dart';

class ListRule extends StatefulWidget {
  const ListRule({super.key});
  @override
  State<ListRule> createState() => _ListRuleState();
}

class _ListRuleState extends State<ListRule> {
  late List<Rule> listRuleSms = [];
  final ConnectToBe connectToBe = ConnectToBe(); // Khởi tạo instance
  bool statusScreen = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      listRuleSms = await connectToBe.fetchRule();
      print("listRuleSms: $listRuleSms");

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                      Text(
                        "Tự Động Hoá",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.red,
                          fontFamily: "Montserrat",
                        ),
                      ),
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
                // Expanded(
                //   flex: 1,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     mainAxisAlignment:
                //         MainAxisAlignment.start, // Căn chỉnh từ trên xuống
                //     children: [
                //       Icon(
                //         Icons.circle_outlined,
                //         color: Colors.red,
                //         size: 40,
                //       ),
                //     ],
                //   ),
                // ),
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
                            "Tạo một mục tự động hóa chạy trên iPhone hoặc iPad cá nhân.",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center, // Căn giữa văn bản
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                // Hành động khi button được nhấn
                              },
                              child: const Text(
                                'Tạo mục tự động hóa cá nhân',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16), // Kiểu chữ
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // Bán kính góc
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
    );
  }
}
