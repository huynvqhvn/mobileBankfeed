import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        color: Colors.red, // Sử dụng Colors.red thay vì "red"
      ),
    );
  }
}
