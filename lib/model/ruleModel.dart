import 'package:floor/floor.dart';
class Rule {
  final String keySearch; // Sửa tên thuộc tính

  const Rule({
    required this.keySearch,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'keySearch': String keySearch,
      } =>
        Rule(
          keySearch: keySearch,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  @override
  String toString() {
    // TODO: implement toString
   return keySearch; 
  }
}