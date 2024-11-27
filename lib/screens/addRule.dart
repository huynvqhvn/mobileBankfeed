import 'package:flutter/material.dart';
import '../model/ruleModel.dart';
import '../service/getDataSevice.dart';

class Addrule extends StatefulWidget {
  @override
  _AddRuleState createState() => _AddRuleState();
}

class _AddRuleState extends State<Addrule> {
  // Biến để lưu lựa chọn của dropdown
  String _selectedOption = 'sms';
  final TextEditingController _keySearchController = TextEditingController();

  @override
  void dispose() {
    _keySearchController.dispose(); // Giải phóng bộ nhớ khi không cần
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
              DropdownButtonFormField<String>(
                value: _selectedOption,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: <String>['sms']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),

              Text(
                "Nhập từ khóa để ghi nhận thông tin:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // TextField để nhập key search
              TextField(
                controller: _keySearchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Người gửi",
                ),
              ),

              SizedBox(height: 20),

              // Nút để thực hiện hành động khi đã nhập xong
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    NativeDataChannel.postRule(
                      _keySearchController.text,
                      _selectedOption,
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
