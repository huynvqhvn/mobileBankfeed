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
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              items: <String>['sms', 'app']
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
              "Key Search:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // TextField để nhập key search
            TextField(
              controller: _keySearchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nhập key search",
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
                  backgroundColor: Colors.red,
                ),
                child:
                    Text('Tạo quy tắc', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
