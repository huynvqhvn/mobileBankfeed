import 'package:flutter/material.dart';
import '../service/getDataSevice.dart';
import '../model/ruleModel.dart';
import 'package:page_transition/page_transition.dart';
import 'addRule.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'updateRule.dart';

class ManagerRule extends StatefulWidget {
  const ManagerRule({super.key});
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
    await Future.delayed(Duration(seconds: 2));
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

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc chắn muốn xóa mục này không?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(false); // Trả về false khi hủy
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () {
                Navigator.of(context).pop(true); // Trả về true khi xác nhận xóa
              },
            ),
          ],
        );
      },
    ).then((value) =>
        value ?? false); // Đảm bảo trả về false nếu hộp thoại bị đóng
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quy tắc nhận dữ liệu",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18), // Sửa ở đây
                          )
                        ]),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text:
                                "! Nếu bạn muốn cập nhật quy tắc hãy ấn vào quy tắc đó\n",
                            style: TextStyle(
                                color: Color(0xFFc93131),
                                fontStyle: FontStyle.italic)),
                        TextSpan(
                            text:
                                "! Nếu bạn muốn xóa quy tắc hay kéo quy tắc sang trái và xác nhận",
                            style: TextStyle(
                                color: Color(0xFFc93131),
                                fontStyle: FontStyle.italic))
                      ]),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listRule.length,
                        itemBuilder: (context, index) {
                          final item = listRule[index];
                          return Dismissible(
                              key: Key(
                                  item.rulesName), // Khóa duy nhất cho mỗi mục
                              background: Container(
                                color: Color(0xFFc93131), // Màu nền khi kéo
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Khoảng cách giữa biểu tượng và văn bản
                                    Text(
                                      "Xóa",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              direction: DismissDirection
                                  .endToStart, // Chỉ cho phép kéo từ phải sang trái
                              confirmDismiss: (direction) async {
                                // Kiểm tra chiều kéo và chỉ hiển thị hộp thoại xác nhận khi kéo đủ một nửa
                                if (direction == DismissDirection.endToStart) {
                                  return await _showConfirmationDialog(context);
                                }
                                return false; // Ngăn chặn xóa nếu không kéo
                              },
                              onDismissed: (direction) async {
                                await NativeDataChannel.deleteRuleDataBase(
                                    item.id, context);
                              },
                              child: GestureDetector(
                                  onTap: () async {
                                    print(
                                        "Đã ấn vào quy tắc: ${item.rulesName}");
                                    final status = await Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        alignment: Alignment.topCenter,
                                        child: Updaterule(rule: item),
                                      ),
                                    );
                                    // Có thể mở hộp thoại chi tiết hoặc trang chỉnh sửa tại đây
                                    if (status == true) {
                                      setState(() {
                                        statusScreen =
                                            false; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
                                      });
                                      initPlatformState(); // Hàm reload danh sách Rule nếu `shouldReload` là `true`
                                    }
                                  },
                                  child: Card(
                                      color: Colors.white,
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
                                                      color: Color(0xFFc93131),
                                                      fontWeight: FontWeight
                                                          .bold), // Sửa ở đây
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
                                                    color: Color(0xFFc93131),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    item.rulesType,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))));
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFFc93131),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
