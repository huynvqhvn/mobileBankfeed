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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animation
                  Lottie.asset('assets/animations/Animation1730347910724.json'),

                  // Text bên dưới animation
                  SizedBox(height: 20), // Khoảng cách giữa animation và text
                  Text(
                    "Bank Feed",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Màu chữ tùy chỉnh
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            nextScreen: BottomNavigationBarExample(),
            splashIconSize: 1000,
          );
        }
      },
    );
  }
}
