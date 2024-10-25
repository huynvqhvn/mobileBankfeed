import 'accountModel.dart';

class Accountlist {
  final List<Account> accounts;

  Accountlist({required this.accounts});

  factory Accountlist.fromJson(Map<String, dynamic> json) {
    var accountList = json['account'] as List; // Lấy danh sách từ JSON
    List<Account> accounts = accountList.map((i) => Account.fromJson(i)).toList();
    return Accountlist(accounts: accounts);
  }
}