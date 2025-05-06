class Wordfiltermodal {
  final int id;
  final String wordsName; // Tên thuộc tính trong lớp
  const Wordfiltermodal({
    required this.id,
    required this.wordsName,
  });

  // Phương thức fromJson để khởi tạo Rule từ Map
  factory Wordfiltermodal.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và lấy giá trị từ JSON Map
    if (json.containsKey('id') && json.containsKey('wordsName')) {
      return Wordfiltermodal(
        id: json['id']?? 0,
        wordsName: json['wordsName'] as String, // Sử dụng 'rule' cho tên trong JSON
      );
    } else {
      throw const FormatException('Failed to load world.');
    }
  }

  @override
  String toString() {
    return '{Wordfiltermodal: $id,wordsName: $wordsName}';
  }
}