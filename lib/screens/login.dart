import 'package:flutter/material.dart';
import '../service/connectBe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController username;
  late final TextEditingController password;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String usernameInput = username.text.trim();
    String passwordInput = password.text.trim();
    final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9";
    ConnectToBe connectToBe = ConnectToBe();
    if (usernameInput == 'a' && passwordInput == '1') {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
       
        Navigator.pushNamed(context, "/bottomnavigation");
      } catch (e) {
        print(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tên đăng nhập hoặc mật khẩu không chính xác.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Feed'),
        backgroundColor:  Color(0xFFc93131),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mật Khẩu',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xFFc93131),
                ),
                child: Text('Đăng Nhập', style: TextStyle(color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {},
                    child: Text('Quên Mật Khẩu',
                        style: TextStyle(color:  Color(0xFFc93131))),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Đăng Nhập Với Google',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
