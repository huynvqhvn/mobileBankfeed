import 'package:flutter/material.dart';
import '../model/ruleModel.dart';
import '../service/getDataSevice.dart';

class Updaterule extends StatefulWidget {
  final Rule rule;
  Updaterule({required this.rule});

  @override
  _UpdateruleState createState() => _UpdateruleState();
}

class _UpdateruleState extends State<Updaterule> {
  // Biến để lưu lựa chọn của dropdown
  String _selectedOption = 'sms';
  late TextEditingController _keySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với giá trị mặc định
    _keySearchController = TextEditingController(text: widget.rule.rulesName);
  }

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
                "Cập Nhật Quy Tắc",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Chọn loại:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Dropdown chọn giữa "sms" và "app"
              DropdownButtonFormField<String>(
                value: widget.rule.rulesType,
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // TextField để nhập key search
              TextField(
                controller: _keySearchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: widget.rule.rulesName,
                ),
              ),

              SizedBox(height: 20),

              // Nút để thực hiện hành động khi đã nhập xong
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Rule newRule = new Rule(
                        id: widget.rule.id,
                        rulesName: _keySearchController.text,
                        rulesType: _selectedOption);
                    NativeDataChannel.updateRuleDataBase(newRule, context);
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
