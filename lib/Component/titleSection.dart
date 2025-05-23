import 'package:flutter/material.dart';
class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
  });

  final String name;
  @override
  Widget build(BuildContext context) {
    return
        /*2*/
        Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Color(0xFFeb4444), // Sử dụng Colors.red thay vì "red"
      ),
    );
  }
}
