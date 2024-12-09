class Rule {
  final int id;
  final String rulesName; // Tên thuộc tính trong lớp
  final String rulesType;
  final int typeId;
  final String typeContent;
  const Rule({
    required this.id,
    required this.rulesName,
    required this.rulesType,
    required this.typeId,
    required this.typeContent,
  });

  // Phương thức fromJson để khởi tạo Rule từ Map
  factory Rule.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và lấy giá trị từ JSON Map
    if (json.containsKey('id') &&
        json.containsKey('rule') &&
        json.containsKey('typesName')&&
        json.containsKey('typeID')&&
        json.containsKey('typesContent')) {
      return Rule(
        id: json['id'] as int,
        rulesName: json['rule'] as String, // Sử dụng 'rule' cho tên trong JSON
        rulesType: json['typesName']
            as String, // Sử dụng 'typeRule' cho loại trong JSON
        typeId: json['typeID']as int,
        typeContent: json['typesContent']as String
      );
    } else {
      throw const FormatException('Failed to load album.');
    }
  }

  @override
  String toString() {
    return '{id: $id, rulesName: $rulesName, rulesType: $rulesType,typeId: $typeId,typeContent: $typeContent}';
  }
}
