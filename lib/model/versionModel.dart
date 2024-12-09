class versionModel {
  final String version; // Tên thuộc tính trong lớp
  final String releaseNotes;
  final int versionId;
  const versionModel({
    required this.version,
    required this.releaseNotes,
    this.versionId = 0,
  });

  // Phương thức fromJson để khởi tạo Rule từ Map
  factory versionModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và lấy giá trị từ JSON Map
    if (json.containsKey('version') && json.containsKey('releaseNotes')) {
      return versionModel(
        versionId: json['id']?? 0,
        version: json['version'] as String, // Sử dụng 'rule' cho tên trong JSON
        releaseNotes: json['releaseNotes'] as String,
      );
    } else {
      throw const FormatException('Failed to load album.');
    }
  }

  @override
  String toString() {
    return '{version: $version,release_notes: $releaseNotes}';
  }
}
