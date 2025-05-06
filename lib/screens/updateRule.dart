import 'package:bank_feed_vs1/model/bankList.dart';
import 'package:flutter/material.dart';
import '../model/ruleModel.dart';
import '../model/wordFilterModal.dart';
import '../service/getDataSevice.dart';
import 'SelectionBankScreen.dart';
import '../service/connectBe.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Updaterule extends StatefulWidget {
  final Rule rule;
  Updaterule({required this.rule});

  @override
  _UpdateruleState createState() => _UpdateruleState();
}

class _UpdateruleState extends State<Updaterule> {
  // Biến để lưu lựa chọn của dropdown
  bool statusScreen = false;
  late String _selectedOptionType = widget.rule.rulesType;
  late String _selectedBankShortName = '';
  late String _selectedBankName = '';
  late String url_logo_Bank = "";
  List<Wordfiltermodal> wordFilterList = [];
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Function setup for Screen
  Future<void> initPlatformState() async {
    BankModel? selectedBank =
        await ConnectToBe.getBankModelWithShortName(widget.rule.rulesName);
    List<Wordfiltermodal> fetchedWordFilterList =
        await NativeDataChannel.getWordFilter(widget.rule.id);
    print("wordFilterList ${fetchedWordFilterList.length}");
    try {
      //check selectedBank null or not and check widget created or not
      if (mounted && selectedBank != null) {
        setState(() {
          wordFilterList = fetchedWordFilterList;
          _selectedBankShortName = selectedBank.shortName;
          _selectedBankName = selectedBank.bankName;
          url_logo_Bank = selectedBank.logo;
          statusScreen =
              true; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
        });
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cập Nhật Quy Tắc",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Chọn loại:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Dropdown chọn giữa "sms" và "app"
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Căn giữa theo chiều ngang
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Bo góc
                              side: BorderSide(
                                color: Colors.grey, // Màu viền
                                width: 1.5, // Độ dày viền
                              ),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      12.0), // Thêm khoảng cách bên trong
                              child: DropdownButtonFormField<String>(
                                value: _selectedOptionType,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                items: <String>['sms', 'app']
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedOptionType = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Ngân hàng",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        // Chuyển đến màn hình lựa chọn và chờ kết quả
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectionBankScreen()),
                        );

                        // Cập nhật giá trị nếu có kết quả trả về
                        if (result != null) {
                          setState(() {
                            _selectedBankShortName = result[2];
                            _selectedBankName = result[1];
                          });
                          setState(() {
                            url_logo_Bank = result[0];
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Bo góc
                              side: BorderSide(
                                color: Colors.grey, // Màu viền
                                width: 1.5, // Độ dày viền
                              ),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  url_logo_Bank != ""
                                      ? Image.network(
                                          url_logo_Bank, // Thay đổi URL này thành URL hình ảnh thực tế
                                          width: 60, // Chiều rộng hình vuông
                                          height: 50, // Chiều cao hình vuông
                                          fit: BoxFit
                                              .contain, // Cách hiển thị hình
                                        )
                                      : Icon(
                                          Icons
                                              .credit_card, // Biểu tượng bạn muốn thêm
                                          color: Colors
                                              .black, // Màu của biểu tượng
                                        ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      _selectedBankName != ""
                                          ? _selectedBankName +
                                              " " +
                                              "(" +
                                              _selectedBankShortName +
                                              ")"
                                          : 'Chọn ngân hàng',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Icon(
                                    Icons
                                        .arrow_right, // Biểu tượng bạn muốn thêm
                                    color: Colors.black, // Màu của biểu tượng
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text:
                                "! Quy tắc giúp bạn thiết lập và quyết định xem dữ liệu nào sẽ gửi lên hệ thống Bankfeeds HVN\n",
                            style: TextStyle(
                                color: Color(0xFFc93131),
                                fontStyle: FontStyle.italic)),
                      ]),
                    ),
                    SizedBox(height: 20),
                    // Nút thêm ô nhập liệu
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Màu nền trắng
                          foregroundColor: Colors.red, // Màu chữ đỏ
                          side: BorderSide(
                              color: Colors.red, width: 1.5), // Viền đỏ
                        ),
                        onPressed: () {
                          // Hiển thị popup khi nhấn nút
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController inputController =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text(
                                  "Thêm từ loại trừ",
                                  style: TextStyle(color: Colors.red),
                                ),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      10.0, // Đặt chiều rộng 80% màn hình
                                  child: TextField(
                                    controller: inputController,
                                    decoration: InputDecoration(
                                      labelText: "Nhập từ loại trừ",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      // bool deleteWordStatus =
                                      //     await NativeDataChannel
                                      //         .deleteWordFilter(
                                      //             widget.rule.id, context);
                                      // if (deleteWordStatus) {
                                      //   await initPlatformState();
                                      // }
                                      Navigator.of(context).pop(); // Đóng popup
                                    },
                                    child: Text(
                                      "Hủy",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red, // Màu nền nút submit
                                      foregroundColor:
                                          Colors.white, // Màu chữ trắng
                                    ),
                                    onPressed: () async {
                                      String inputData = inputController.text;
                                      if (inputData.isNotEmpty) {
                                        bool isAdded = await NativeDataChannel
                                            .addWordFilter(inputData,
                                                widget.rule.id, context);
                                        if (isAdded) {
                                          // Gọi lại hàm load dữ liệu
                                          await initPlatformState();
                                        }
                                      } else {
                                        // Hiển thị thông báo nếu không nhập dữ liệu
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text("Vui lòng nhập từ loại trừ"),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Color(0xFFc93131),
                                        ));
                                      }
                                      Navigator.of(context).pop(); // Đóng popup
                                    },
                                    child: Text("Submit"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("Thêm từ loại trừ"),
                      ),
                    ),
                    SizedBox(height: 20),
                    wordFilterList.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0), // Thêm khoảng cách bên phải
                              child: Scrollbar(
                                thumbVisibility:
                                    true, // Hiển thị thanh cuộn luôn luôn
                                child: ListView.builder(
                                  itemCount: wordFilterList.length,
                                  itemBuilder: (context, index) {
                                    final word = wordFilterList[index];
                                    return Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5), // Bo góc
                                        side: BorderSide(
                                          color: Colors.grey, // Màu viền
                                          width: 1.5, // Độ dày viền
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          word.wordsName,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () async {
                                            // Xóa từ khỏi danh sách
                                            bool isDeleted =
                                                await NativeDataChannel
                                                    .deleteWordFilter(
                                                        word.id, context);
                                            if (isDeleted) {
                                              setState(() {
                                                wordFilterList.removeAt(index);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Danh sách từ loại trừ trống",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                    SizedBox(height: 20),
                    // Nút để thực hiện hành động khi đã nhập xong
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Rule ruleUpdate = new Rule(
                              id: widget.rule.id,
                              rulesName: _selectedBankShortName,
                              rulesType: _selectedOptionType,
                              typeContent: widget.rule.typeContent,
                              typeId: widget.rule.typeId);
                          NativeDataChannel.updateRuleDataBase(
                              ruleUpdate, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFc93131),
                        ),
                        child: Text('Cập nhật quy tắc',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
