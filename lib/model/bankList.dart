class BankModel {
  int id;
  String bankName; // Tên thuộc tính trong lớp
  String bankCode;
  String shortName;
  String logo;
  bool appSupport;

  BankModel(
      {required this.id,
      required this.bankName,
      required this.bankCode,
      required this.shortName,
      required this.logo,
      this.appSupport = false});

  // Phương thức fromJson để khởi tạo BankModel từ Map
  factory BankModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và lấy giá trị từ JSON Map
    if (json.containsKey('id') &&
        json.containsKey('name') &&
        json.containsKey('code') &&
        json.containsKey('shortName') &&
        json.containsKey('logo')) {
      return BankModel(
          id: json['id'] as int,
          bankName: json['name'] as String,
          bankCode: json['code'] as String,
          shortName: json['shortName'] as String,
          logo: json['logo'] as String,
          appSupport: json['appSupport'] ?? false);
    } else {
      throw const FormatException('Failed to load album.');
    }
  }
  // Phương thức cập nhật appSupport
  void updateAppSupport(bool value) {
    appSupport = value;
  }

  @override
  String toString() {
    return '{id: $id, bankName: $bankName, bankCode: $bankCode,shortName: $shortName,logo: $logo}';
  }
}
