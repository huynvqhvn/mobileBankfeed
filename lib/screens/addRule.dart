import 'package:flutter/material.dart';
import '../model/ruleModel.dart';
import '../service/getDataSevice.dart';
import 'SelectionBankScreen.dart';

class Addrule extends StatefulWidget {
  @override
  _AddRuleState createState() => _AddRuleState();
}

class _AddRuleState extends State<Addrule> {
  // Biến để lưu lựa chọn của dropdown
  String _selectedOptionType = 'sms';
  String _selectedBankShortName = '';
  String _selectedBankName = '';
  late String url_logo_Bank = "";
  @override
  void dispose() {
    super.dispose();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm Quy Tắc",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Chọn loại:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Dropdown chọn giữa "sms" và "app"
              Row(children: [
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
                  child: DropdownButtonFormField<String>(
                    value: _selectedOptionType,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: InputBorder.none,
                    ),
                    items: <String>['sms', 'app']
                        .map((String value) => DropdownMenuItem<String>(
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
                ))
              ]),
              SizedBox(height: 20),

              Text(
                "Ngân hàng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                    fit: BoxFit.contain, // Cách hiển thị hình
                                  )
                                : Icon(
                                    Icons
                                        .credit_card, // Biểu tượng bạn muốn thêm
                                    color: Colors.black, // Màu của biểu tượng
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
                              Icons.arrow_right, // Biểu tượng bạn muốn thêm
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

              // Nút để thực hiện hành động khi đã nhập xong
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    NativeDataChannel.postRule(
                      _selectedBankShortName,
                      _selectedOptionType,
                      context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFc93131),
                  ),
                  child: Text('Tạo quy tắc',
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
