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
      id: json['id'] ?? 0, // Sử dụng 0 nếu `id` là null
      author:
          json['author'] ?? "Unknown", // Sử dụng "Unknown" nếu `author` là null
      message: json['message'] ??
          "No message", // Sử dụng "No message" nếu `messages` là null
      timestamp:
          json['timestamp'] ?? "", // Sử dụng chuỗi rỗng nếu `timestamp` là null
      isSendMessage: json['isSendMessage'] ??
          false, // Sử dụng false nếu `isSendMessage` là null
    );
  }
  @override
  String toString() {
    return '{id: $id, author: $author, message: $message, timestamp: ${DateTime.parse(timestamp)}}';
  }
}
