import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:todo/config.dart';
import 'package:todo/screens/auth.dart';
// import 'package:todo/models/list.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({
    super.key,
    this.token,
  });
  final token;

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late String email;
  late String userId;
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _discriptioncontroller = TextEditingController();
  List? todoItems = [];

  void _submit() async {
    if (_titlecontroller.text.trim().isNotEmpty &&
        _discriptioncontroller.text.trim().isNotEmpty) {
      var reqBody = {
        "userId": userId,
        "title": _titlecontroller.text,
        "disc": _discriptioncontroller.text
      };

      var response = await http.post(
        Uri.parse("${url}storeTodo"),
        body: jsonEncode(reqBody),
        headers: {"Content-Type": "Application/json"},
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        setState(() {
          getTodo(userId);
          Navigator.pop(context);
        });
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter both title and discription'),
        ),
      );
    }

    _titlecontroller.clear();
    _discriptioncontroller.clear();
  }

  void createTodo() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
                controller: _titlecontroller,
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: 'Discription',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
                controller: _discriptioncontroller,
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      _titlecontroller.clear();
                      _discriptioncontroller.clear();

                      Navigator.of(context).pop();
                    },
                    child: const Text('cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('submit'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void getTodo(userId) async {
    var reqBody = {
      "userId": userId,
    };
    var response = await http.post(
      Uri.parse('${url}getUserTodo'),
      headers: {"Content-Type": "Application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    todoItems = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    var reqBody = {
      "id": id,
    };

    var response = await http.post(
      Uri.parse('${url}deleteTodo'),
      headers: {"Content-Type": "Application/json"},
      body: jsonEncode(reqBody),
    );

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status'])
    {
        getTodo(userId);
    }
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    email = jwtDecodedToken['email'];
    userId = jwtDecodedToken['_id'];

    getTodo(userId);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _discriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.star),
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTodo,
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Expanded(
        child: todoItems == null || todoItems!.isEmpty
            ? const Center(
                child: Text('Try adding some hobbies!!!'),
              )
            : ListView.builder(
                itemCount: todoItems!.length,
                itemBuilder: (context, index) => Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(12),
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (BuildContext context) {
                          deleteItem(todoItems![index]['_id']);
                        },
                      )
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade500),
                    child: ListTile(
                      title: Text(
                        todoItems![index]['title'],
                      ),
                      subtitle: Text(todoItems![index]['disc']),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
