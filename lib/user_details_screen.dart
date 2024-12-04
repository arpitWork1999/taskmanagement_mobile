import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_tool/service/database.dart';
import 'package:task_management_tool/widgets/custom_list_class.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.id});

  final dynamic id;
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  DatabaseMethods databaseMethods = DatabaseMethods();
    List<dynamic> assignedTaskNameList = [];
    List<dynamic> assignedProjectNameList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () async {
                try {
                  ListContainer projectNameList = await databaseMethods.matchAndRetrieve(widget.id);
                  setState(() {
                    assignedProjectNameList = projectNameList.list1;
                  });
          
                  if (assignedProjectNameList.isNotEmpty) {
                    customTaskNameList(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No users assigned to this project.')),
                    );
                  }
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error fetching users: $e')),
                  );
                }
                //databaseMethods.fetchUserDetails(widget.id);
                //databaseMethods.matchAndRetrieve(widget.id);
              },
              icon: const Icon(Icons.arrow_drop_down_circle_outlined)),

               IconButton(
              onPressed: () async {
                try {
                 ListContainer taskNameList =
                      await databaseMethods.matchAndRetrieve(widget.id);
                  setState(() {
                    assignedTaskNameList = taskNameList.list2;
                  });
          
                  if (assignedTaskNameList.isNotEmpty) {
                    secondCustomTaskNameList(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No users assigned to this project.')),
                    );
                  }
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error fetching users: $e')),
                  );
                }
                //databaseMethods.fetchUserDetails(widget.id);
                //databaseMethods.matchAndRetrieve(widget.id);
              },
              icon: const Icon(Icons.arrow_drop_down_circle_outlined)),

        ],
      ),
    );
  }

  void customTaskNameList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Assigned projects to this user",
                  style: GoogleFonts.fredoka(
                      fontSize: 20.sp, fontWeight: FontWeight.w400),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 30,
                ),
              ),
            ],
          ),
          content: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width * 0.8, // Adjust width
              child: ListView.builder(
                itemCount: assignedProjectNameList.length,
                itemBuilder: (context, index) {
                  String projectName = assignedProjectNameList[index];
                  // var data = assignedTaskNameList[index];
                  // String name = data["TaskName"];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      projectName,
                      style: GoogleFonts.fredoka(
                        fontSize: 20.sp,
                      ),
                    ),
                  );
                },
              )),
        );
      },
    );
  }
  void secondCustomTaskNameList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Assigned tasks to this user",
                  style: GoogleFonts.fredoka(
                      fontSize: 25.sp, fontWeight: FontWeight.w400),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 40,
                ),
              ),
            ],
          ),
          content: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width * 0.8, // Adjust width
              child: ListView.builder(
                itemCount: assignedTaskNameList.length,
                itemBuilder: (context, index) {
                  dynamic name = assignedTaskNameList[index];
                  // var data = assignedTaskNameList[index];
                  // String name = data["TaskName"];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      name,
                      style: GoogleFonts.fredoka(
                        fontSize: 20.sp,
                      ),
                    ),
                  );
                },
              )),
        );
      },
    );
  }
}
