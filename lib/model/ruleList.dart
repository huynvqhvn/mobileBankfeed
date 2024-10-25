import 'accountModel.dart';
import 'ruleModel.dart';
class Rulelist {
  final List<Rule> rules;

  Rulelist({required this.rules});

  factory Rulelist.fromJson(Map<String, dynamic> json) {
    var ruleList = json as List; // Lấy danh sách từ JSON
    List<Rule> rules = ruleList.map((i) => Rule.fromJson(i)).toList();
    return Rulelist(rules: rules);
  }
}