
import 'package:flutter/material.dart';
import 'screens/listRule.dart';
import 'Component/bottomNavigationBar.dart';
import 'service/requestSms.dart';
import 'screens/login.dart';
import 'screens/splash_screen.dart';
import 'service/connectBe.dart';
import 'service/permistion.dart';
/// Flutter code sample for [BottomNavigationBar].

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
  PermissionService permissionService = PermissionService();
  @override
  void initState() {
    super.initState();
     _initializeData();
  }
  
  Future<void> _initializeData() async {
    // bool hasPermission =
    //     await permissionService.checkSmsPermission(); // Kiểm tra quyền
    // await permissionService.getSms(hasPermission);
    // await connectToBe.fetchAccount(); // Lấy tài khoản
    await NotificationAccessHelper.requestSmsPermission();
    await NotificationAccessHelper.openNotificationAccessSettings();
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
