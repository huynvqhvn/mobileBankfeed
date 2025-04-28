import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreen();
}

class _SupportScreen extends State<SupportScreen> {
  bool statusScreen = false;
  late String? idService = "";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      if (mounted) {
        setState(() {
          statusScreen = true;
        });
      } else {
        setState(() {
          statusScreen = true;
        });
      }
    } catch (e) {
      print("Có lỗi xảy ra: $e");
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _copyAndSave(BuildContext context) async {
    // Sao chép dữ liệu vào clipboard
    await Clipboard.setData(ClipboardData(text: idService!));

    // Lưu dữ liệu vào bộ nhớ tạm
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/clipboard_data.txt');
    await file.writeAsString(idService!);

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép: $idService'),
        backgroundColor: Colors.green,
      ),
    );
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
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                // Sử dụng Expanded để chiếm hết không gian có sẵn
                                child: Text(
                                  "Thông tin ứng dụng",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true, // Cho phép xuống dòng
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Giữ các widget ở đầu
                            children: [
                              Icon(Icons.app_registration,
                                  color: Color(0xFFeb4444)),
                              SizedBox(width: 8),
                              Text(
                                "Tên ứng dụng : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                              SizedBox(
                                  width:
                                      8), // Thêm khoảng cách giữa hai văn bản
                              Text(
                                "BankFeeds",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Giữ các widget ở đầu
                            children: [
                              Icon(Icons.location_city,
                                  color: Color(0xFFeb4444)),
                              SizedBox(width: 8),
                              Text(
                                "Đơn vị sở hữu : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                              SizedBox(
                                  width:
                                      8), // Thêm khoảng cách giữa hai văn bản
                              Text(
                                "Tập Đoàn HVN",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Giữ các widget ở đầu
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on, color: Color(0xFFeb4444)),
                              SizedBox(width: 8),
                              Text(
                                "Địa chỉ : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  " VP Hà Nội: TT02-15, KĐT Mon City, Nam Từ Liêm, HN",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  softWrap: true, // Cho phép xuống dòng
                                ),
                              ) // Thêm khoảng cách giữa hai văn bản
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Giữ các widget ở đầu
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.email, color: Color(0xFFeb4444)),
                              const SizedBox(width: 8),
                              const Text(
                                "Email:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  "  kinhdoanh@hvn.vn",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  softWrap: true, // Cho phép xuống dòng
                                ),
                              ),
                              // Thêm khoảng cách giữa hai văn bản
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Giữ các widget ở đầu
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.email, color: Color(0xFFeb4444)),
                              SizedBox(width: 8),
                              Text(
                                "Email:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true, // Cho phép xuống dòng
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "  kythuat@hvn.vn",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  softWrap: true, // Cho phép xuống dòng
                                ),
                              ) // Thêm khoảng cách giữa hai văn bản
                            ],
                          ),
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment
                                .bottomCenter, // Cố định nút ở giữa dưới
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFc93131)),
                                // Sửa lỗi ở đây
                              ),
                              onPressed: () {
                                _makePhoneCall("0777.247.777");
                              },
                              child: Text(
                                'Hotline kỹ thuật: 0777.247.777',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment
                                .bottomCenter, // Cố định nút ở giữa dưới
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFc93131)),
                                // Sửa lỗi ở đây
                              ),
                              onPressed: () {
                                _makePhoneCall("02499997777");
                              },
                              child: Text(
                                'Hotline kinh doanh:  024.9999.7777',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center, // Căn giữa nút
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFc93131)),
                              ),
                              onPressed: () async {
                                const url =
                                    'https://example.com'; // Thay bằng link của bạn
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  // Hiển thị thông báo nếu không mở được link
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Không thể mở liên kết'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Điều khoản và chính sách',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ))));
  }
}
