import 'package:flutter/material.dart';
import '../service/getDataSevice.dart';
import '../model/ruleModel.dart';
import 'package:page_transition/page_transition.dart';
import 'addRule.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManagerRule extends StatefulWidget {
  @override
  _ManagerRule createState() => _ManagerRule();
}

class _ManagerRule extends State<ManagerRule> {
  late List<Rule> listRule = [];
  bool statusScreen = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không cần
    super.dispose();
  }

  Future<void> initPlatformState() async {
    await Future.delayed(Duration(seconds: 3));
    try {
      listRule = await NativeDataChannel.getRule();
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
                    Text(
                      "Các Quy Tắc",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listRule.length,
                        itemBuilder: (context, index) {
                          final item = listRule[index];
                          return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final status = await Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              alignment: Alignment.topCenter,
              child: Addrule(),
            ),
          );
          if (status == true) {
            setState(() {
              statusScreen =
                  false; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
            });
            initPlatformState(); // Hàm reload danh sách Rule nếu `shouldReload` là `true`
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
