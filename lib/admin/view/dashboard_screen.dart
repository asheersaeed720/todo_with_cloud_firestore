import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:todo_with_cloud_firestore/admin/dashboard_controller.dart';
import 'package:todo_with_cloud_firestore/auth/auth_controller.dart';
import 'package:todo_with_cloud_firestore/widgets/loading_indicator.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authController = Get.find<AuthController>();

  final _dashController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: _dashController.getAllUsers(_authController.userData['uid']),
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
                              '${snapshot.data?.docs[i]['email']}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            trailing: Wrap(
                              spacing: 22.0,
                              children: [
                                snapshot.data?.docs[i]['is_active']
                                    ? InkWell(
                                        onTap: () {
                                          _dashController
                                              .activeUser('${snapshot.data?.docs[i].id}');
                                        },
                                        child: Text(
                                          'Active',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          _dashController
                                              .dectiveUser('${snapshot.data?.docs[i].id}');
                                        },
                                        child: Text(
                                          'Deactive',
                                          style: TextStyle(color: Colors.red),
                                        ),
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
    );
  }
}
