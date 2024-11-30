import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/auth.dart';
import 'package:todo/screens/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.token,
  });

  final token;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JwtDecoder.isExpired(token)
          ? const AuthScreen()
          : ToDoScreen(
              token: token,
            ),
    );
  }
}
