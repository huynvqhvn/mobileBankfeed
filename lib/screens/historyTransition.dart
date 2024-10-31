import 'package:flutter/material.dart';
import '../service/getDataSevice.dart';
import '../model/smsModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HistoryTransition extends StatefulWidget {
  const HistoryTransition({super.key});
  @override
  State<HistoryTransition> createState() => _HistoryTransitionState();
}

class _HistoryTransitionState extends State<HistoryTransition> {
  late List<SmsModel> listSms = [];
  bool statusScreen = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Future.delayed(Duration(seconds: 3));
    try {
      listSms = await NativeDataChannel.getNativeData();
      print("listSmsLEngth: ${listSms.length}");
      // Kiểm tra xem danh sách có rỗng không
      if (listSms.isNotEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Feed"),
        centerTitle: true,
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            !statusScreen
                ? Align(
                    alignment: Alignment.center,
                    child: LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.red,
                      rightDotColor: Colors.blue,
                      size: 50,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: listSms.length,
                      itemBuilder: (context, index) {
                        final item = listSms[index];
                        return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Nguồn nhận: ",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight:
                                                FontWeight.bold), // Sửa ở đây
                                      ),
                                      Text(item.author),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "Nội dung:  ",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.message,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "Thời gian:  ",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.timestamp,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                       Text("Trạng thái:  ",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item.isSendMessage
                                            ? "Đã Đồng Bộ"
                                            : "Chưa Đồng Bộ",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
