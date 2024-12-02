import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../service/connectBe.dart';
import '../model/bankList.dart';

class SelectionBankScreen extends StatefulWidget {
  @override
  _SelectionBankScreen createState() => _SelectionBankScreen();
}

class _SelectionBankScreen extends State<SelectionBankScreen> {
  bool statusScreen = false;
  late List<BankModel> listBanks = [];
  late List<BankModel> listBanksSave = [];
  final TextEditingController _keySearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    _keySearchController.dispose();
    super.dispose();
  }

  // Function setup for Screen
  Future<void> initPlatformState() async {
    await Future.delayed(Duration(seconds: 2));
    listBanks = await ConnectToBe.getBankModelList();
    listBanksSave = listBanks;
    print("checklistBank: ${listBanks}");
    try {
      if (mounted && listBanks.isNotEmpty) {
        setState(() {
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

  // Function to search bank by name or shortname
  Future<void> SearchBanks(valueSearch) async {
    print("valueSearch : ${valueSearch}");
    List<BankModel> listBankSearch = [];
    if (valueSearch != "" && listBanks.isNotEmpty) {
      //loop to each bank in list
      for (int i = 0; i < listBanks.length; i++) {
        if (listBanks[i].bankName.toLowerCase().contains(valueSearch) ||
            listBanks[i].shortName.toLowerCase().contains(valueSearch) ||
            listBanks[i].shortName == valueSearch ||
            listBanks[i].bankName == valueSearch) {
          listBankSearch.add(listBanks[i]);
        }
      }
    }
    print("check list ${listBankSearch}");
    if (listBankSearch.length > 0) {
      setState(() {
        listBanks =
            listBankSearch; // Đặt trạng thái là true khi đã hoàn thành việc lấy dữ liệu
      });
    } else {
      setState(() {
        listBanks = listBanksSave;
      });
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
                      children: [
                        Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                                onChanged: (value) {
                                  SearchBanks(value);
                                },
                                controller: _keySearchController,
                                decoration: const InputDecoration(
                                  hintText: "Tìm kiếm ngân hàng",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search, // Biểu tượng tìm kiếm
                                    color: Colors.grey, // Màu của biểu tượng
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                )),
                          ),
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listBanks.length,
                            itemBuilder: (context, index) {
                              final item = listBanks[index];
                              return Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Image.network(
                                      item.logo, // Thay đổi URL này thành URL hình ảnh thực tế
                                      width: 90, // Chiều rộng hình vuông
                                      height: 50, // Chiều cao hình vuông
                                      fit: BoxFit.contain, // Cách hiển thị hình
                                    ),
                                    title: Text(item.shortName),
                                    subtitle: Text(item.bankName),
                                    onTap: () {
                                      // Trở về màn hình trước với giá trị đã chọn
                                      Navigator.pop(context, [
                                        item.logo,
                                        item.bankName,
                                        item.shortName
                                      ]);
                                    },
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
            )));
  }
}
