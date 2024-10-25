
import 'package:flutter/material.dart';
import '../screens/listRule.dart';
import '../screens/Account.dart';
class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});
  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    ListRule(),
    AccountSetting(),
    AccountSetting()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Danh sách quy tắc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chair_alt),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Tài Khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red.shade600,
        onTap: _onItemTapped,
      ),
    );
  }
}
