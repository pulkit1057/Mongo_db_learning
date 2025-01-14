import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/auth.dart';
import 'package:todo/screens/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.token,
  });

  final String? token;

  @override
  Widget build(BuildContext context) {
    if (token == null || JwtDecoder.isExpired(token!)) {
      return MaterialApp(
        home: const AuthScreen(),
      );
    } else {
      return MaterialApp(
        home: ToDoScreen(
          token: token!,
        ),
      );
    }
  }
}
