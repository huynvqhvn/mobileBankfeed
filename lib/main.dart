import 'package:flutter/material.dart';
import 'screens/listRule.dart';
import 'Component/bottomNavigationBar.dart';
import 'screens/login.dart';
import 'screens/splash_screen.dart';
import 'service/connectBe.dart';
import 'service/permistion.dart';
import 'service/getDataSevice.dart';

void main() async {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectToBe connectToBe = ConnectToBe();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await NotificationAccessHelper.requestSmsPermission();
    await NotificationAccessHelper.openNotificationAccessSettings();
    await NativeDataChannel.checkAndSaveSerial();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey.shade400,
          background: Colors.grey[200],
        ),
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/addrule': (context) => ListRule(),
        '/login': (context) => LoginScreen(),
        '/bottomnavigation': (context) => BottomNavigationBarExample(),
      },
    );
  }
}
