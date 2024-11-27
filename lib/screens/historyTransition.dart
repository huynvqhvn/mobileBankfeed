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
  bool statusAsync = false;
  bool statusScreen = false;
  bool light = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      listSms = await NativeDataChannel.getNativeData();
      statusAsync = await NativeDataChannel.getStatusAsync();
      print("statusAsync ${statusAsync}");
      // Kiểm tra xem danh sách có rỗng không
      if (listSms.isNotEmpty) {
        if (mounted) {
          setState(() {
            statusScreen =
                true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
            light = statusAsync;
          });
        }
      } else {
        setState(() {
          statusScreen =
              true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
          light = statusAsync;
        });
      }
    } catch (e) {
      print("Có lỗi xảy ra: $e");
    }
  }

  Future<void> settingAsync(bool valueBool) async {
    //check webhook exits
    String? useWeebHook = "";
    useWeebHook = await NativeDataChannel.getDataWebhook();
    print("${useWeebHook}+ useWeebHook");
    if (useWeebHook != null &&
        useWeebHook.isNotEmpty &&
        useWeebHook.length > 0) {
      var bool = await NativeDataChannel.postStatusAsync(valueBool);
      setState(() {
        light =
            valueBool; // Cập nhật giá trị của light nếu useWeebHook có giá trị
      });
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ webhook của bạn'),
          backgroundColor: Colors.blue,
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
          backgroundColor: Color(0xFFc93131),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: !statusScreen
                ? Align(
                    alignment: Alignment.center,
                    child: LoadingAnimationWidget.staggeredDotsWave(
                    color:  Color(0xFFc93131),
                    size: 50,
                  ),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tự động đồng bộ hóa dữ liệu",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18), // Sửa ở đây
                          ),
                          Switch(
                            // This bool value toggles the switch.
                            value: light,
                            activeColor:  Color(0xFFc93131),
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              settingAsync(value);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            // Sử dụng Expanded để chiếm hết không gian có sẵn
                            child: Text(
                              "Nếu bạn kích hoạt tự đồng bộ hóa dữ liệu hệ thống sẽ tự đồng bộ dữ liệu mỗi 10s",
                              style: TextStyle(
                                color:  Color(0xFFc93131),
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                              softWrap: true, // Cho phép xuống dòng
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: listSms.length,
                          itemBuilder: (context, index) {
                            final item = listSms[index];
                            return Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Nguồn nhận: ",
                                            style: TextStyle(
                                                color:  Color(0xFFc93131),
                                                fontWeight: FontWeight
                                                    .bold), // Sửa ở đây
                                          ),
                                          Text(item.author),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nội dung:  ",
                                            style: TextStyle(
                                              color:  Color(0xFFc93131),
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
                                              color:  Color(0xFFc93131),
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
                                          Text(
                                            "Trạng thái:  ",
                                            style: TextStyle(
                                              color:  Color(0xFFc93131),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item.isSendMessage
                                                ? "Đã Đồng Bộ"
                                                : "Chưa Đồng Bộ",
                                            style: TextStyle(
                                              color: item.isSendMessage
                                                  ? Colors.green
                                                  :  Color(0xFFc93131),
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
        ));
  }
}
