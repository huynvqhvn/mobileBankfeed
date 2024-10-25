import 'package:floor/floor.dart';

@entity
class SmsModel {
  @PrimaryKey(autoGenerate: true)
   int? id; // Đây sẽ được tự động sinh
   String author;
   String message;
   String timestamp;
   bool isSendMessage;

  SmsModel({
    this.id, // Chỉ cần khai báo là có thể null, không bắt buộc phải có khi tạo mới
    required this.author,
    required this.message,
    required this.timestamp,
    required this.isSendMessage,
  });

  factory SmsModel.fromJson(Map<String, dynamic> json) {
    return SmsModel(
      id: json['id'] != null
          ? json['id'] as int
          : null, // Có thể null nếu là bản ghi mới
      author: json['author'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      isSendMessage: json['isSendMessage'] as bool,
    );
  }

  @override
  String toString() {
    return 'SmsModel{id: $id, author: $author, message: $message, timestamp: ${DateTime.parse(timestamp)}}';
  }
}
