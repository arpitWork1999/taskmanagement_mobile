import 'package:flutter/material.dart';
import 'package:task_management_tool/service/database.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.id});

  final dynamic id;
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Container(
        child: IconButton(
            onPressed: () {
              //databaseMethods.fetchUserDetails(widget.id);
            },
            icon: const Icon(Icons.arrow_drop_down_circle_outlined)),
      ),
    );
  }
}
