import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_with_cloud_firestore/auth/auth_controller.dart';
import 'package:todo_with_cloud_firestore/home/todo_controller.dart';
import 'package:todo_with_cloud_firestore/utils/input_decoration.dart';
import 'package:todo_with_cloud_firestore/widgets/custom_button.dart';
import 'package:todo_with_cloud_firestore/widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authController = Get.find<AuthController>();
  final _todoController = Get.find<TodoController>();

  GlobalKey<FormState> _formKeyTodo = GlobalKey<FormState>();

  TextEditingController _todoTextEditingController = TextEditingController(text: '');

  String currentUpdateId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _authController.signOutUser();
              },
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(14.0),
        child: Form(
          key: _formKeyTodo,
          child: Column(
            children: [
              TextFormField(
                controller: _todoTextEditingController,
                validator: (value) => value!.isEmpty ? "Required" : null,
                keyboardType: TextInputType.text,
                decoration: buildTextFieldInputDecoration(context, txt: 'Title'),
              ),
              const SizedBox(height: 16.0),
              Obx(
                () => _todoController.isUpdate.value
                    ? CustomButton(
                        width: double.infinity,
                        btnTxt: 'Update',
                        onPressed: () {
                          if (_formKeyTodo.currentState!.validate()) {
                            _todoController.updateTodo(currentUpdateId,
                                _authController.userData['uid'], _todoTextEditingController.text);
                            _formKeyTodo.currentState?.reset();
                          }
                        },
                      )
                    : CustomButton(
                        width: double.infinity,
                        btnTxt: 'Add',
                        onPressed: () {
                          if (_formKeyTodo.currentState!.validate()) {
                            _todoController.addTodo(
                                _authController.userData['uid'], _todoTextEditingController.text);
                            _formKeyTodo.currentState?.reset();
                          }
                        },
                      ),
              ),
              const Divider(height: 32.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _todoController.findAllTodos(_authController.userData['uid']),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return Text('${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: LoadingIndicator());
                      default:
                        return snapshot.data?.docs.length == 0
                            ? Center(
                                child: Text('Empty'),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: Text(
                                      '${snapshot.data?.docs[i]['title']}',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    trailing: Wrap(
                                      spacing: 18.0,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Map data = {
                                            //   "uid": "${_authController.userData['uid']}",
                                            //   "title": "${_todoTextEditingController.text}",
                                            // };
                                            // _todoController.updateTodo(
                                            //   '${snapshot.data?.docs[i].id}',
                                            //   data,
                                            // );
                                            _todoController.isUpdate.value = true;
                                            _todoTextEditingController.text =
                                                '${snapshot.data?.docs[i]['title']}';
                                            currentUpdateId = '${snapshot.data?.docs[i].id}';
                                          },
                                          child: Icon(Icons.edit, color: Colors.blue),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _todoController
                                                .deleteTodo('${snapshot.data?.docs[i].id}');
                                          },
                                          child: Icon(Icons.delete, color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
