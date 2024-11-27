import 'package:flutter/material.dart';
import '../screens/listRule.dart';
import '../screens/historyTransition.dart';
import '../screens/managerRule.dart';
import '../screens/supportScreen.dart';
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
    ManagerRule(),
    HistoryTransition(),
    SupportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
           backgroundColor: Color(0xFFc93131),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Quy tắc',
           backgroundColor: Color(0xFFc93131),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Giao dịch',
           backgroundColor: Color(0xFFc93131),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hỗ trợ',
           backgroundColor: Color(0xFFc93131),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
