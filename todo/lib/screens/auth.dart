import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/config.dart';
import 'package:todo/screens/todo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedpref();
  }

  void initSharedpref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _submit() async {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      if (!isLogin) {
        var response = await http.post(
            Uri.parse('${url}registeration'),
            body: jsonEncode(reqBody),
            headers: {"Content-Type": "Application/json"});

        var jsonResponse = await jsonDecode(response.body);

        if (jsonResponse['status']) {
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email already exists'),
            ),
          );
          return;
        }
      }
      var response = await http.post(
        Uri.parse('${url}login'),
        body: jsonEncode(reqBody),
        headers: {"Content-Type": "Application/json"},
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ToDoScreen(
              token: myToken,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password or you are not registered'),
          ),
        );
      }
      emailController.clear();
      passwordController.clear();
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid credentials'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          isLogin ? "Sign in" : "Sign up",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? 'Register' : 'Already have an account?',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
