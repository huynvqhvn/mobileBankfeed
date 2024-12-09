import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import '../service/getDataSevice.dart';
import '../model/versionModel.dart';
class DialogComponent extends StatefulWidget {
  final String version;
  DialogComponent({required this.version});

  @override
  State<DialogComponent> createState() => _DialogComponentState();
}

class _DialogComponentState extends State<DialogComponent> {
  bool statusScreen = false; // Trạng thái tiến trình
  bool showLoading = false; // Trạng thái hiển thị loading
  bool isDialogVisible = false; // Cờ kiểm tra dialog đang hiển thị
  late String version ="";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  Future<void> initPlatformState() async {
     versionModel? versionCurrent = await NativeDataChannel.getVersion();
     setState(() {
       version = versionCurrent!.version;
     });
  }
  // Hàm mở tệp APK
  void openApk(String filePath) async {
    if (await NativeDataChannel.requestInstallPermission()) {
      final result = await OpenFile.open(filePath);
      print("open result ${result}");
    } else {
      print("Không thể mở tệp APK");
    }
  }

  // Hàm hiển thị Dialog
  void _showDialog(BuildContext context) {
    if (isDialogVisible) return; // Nếu dialog đang mở, không mở thêm
    isDialogVisible = true;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Thông báo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  showLoading
                      ? const Text("Hệ thống đang tự động cập nhật")
                      :  Text(
                          "Phiên bản $version của bạn đã cũ, bạn muốn cập nhật app?"),
                  const SizedBox(height: 20),
                  showLoading
                      ? (statusScreen
                          ? Align(
                              alignment: Alignment.center,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Color(0xFFc93131),
                                size: 50,
                              ),
                            )
                          : const Icon(Icons.check))
                      : const SizedBox.shrink(),
                ],
              ),
              actions: [
                showLoading
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          isDialogVisible =
                              false; // Đặt lại trạng thái khi đóng
                        },
                        child: const Text("Đóng"),
                      ),
                showLoading
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () async {
                          final url =
                              "https://id.staging.hvn.vn/apkTest/BankFeed.apk";

                          setDialogState(() {
                            showLoading = true;
                            statusScreen = true;
                          });

                          FileDownloader.downloadFile(
                            url: url,
                            onDownloadError: (String error) {
                              print("Lỗi tải xuống: $error");
                              Navigator.of(context).pop();
                              isDialogVisible = false;
                            },
                            onDownloadCompleted: (String path) async {
                              openApk(path);
                              Navigator.of(context).pop();
                              setDialogState(() {
                                showLoading = false;
                                statusScreen = false;
                              });
                              isDialogVisible = false;
                            },
                            onProgress: (fileName, progress) {
                              print("Tiến trình tải: $progress");
                            },
                          );
                        },
                        child: const Text("Xác nhận"),
                      ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Đặt lại trạng thái dialog khi nó bị đóng
      isDialogVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.version == "notSame") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDialog(context);
      });
    }

    return const SizedBox.shrink();
  }
}
