import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'login.dart';
import '../Component/bottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> _checkLoginStatus;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus = _getToken(); // Gọi hàm kiểm tra token
  }

  Future<bool> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    return accessToken != null; // Trả về true nếu đã đăng nhập
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Hiển thị loading
        } else {
          return AnimatedSplashScreen(
            duration: 5000,
            splash: Center(
              child: Lottie.asset('assets/animations/Animation - 1728007741606.json'),
            ),
            nextScreen: snapshot.data == true ? BottomNavigationBarExample() : LoginScreen(), // Chọn màn hình tiếp theo
            splashIconSize: 1000,
          );
        }
      },
    );
  }
}
