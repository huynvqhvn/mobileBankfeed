import 'package:flutter/material.dart';

class Addrule extends StatefulWidget {
  const Addrule({super.key});
  @override
  State<Addrule> createState() => _Addrule();
}

class _Addrule extends State<Addrule> {
  bool statusScreen = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      // Kiểm tra xem danh sách có rỗng không
      if (mounted) {
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
        backgroundColor:  Color(0xFFc93131),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
    );
  }
}
