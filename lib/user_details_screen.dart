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

  bool isLoading = true;

  List<dynamic> assignedTaskNameList = [];
  List<dynamic> assignedProjectNameList = [];

  @override
  void initState() {
    super.initState();
    fethData();
    getProjectData();
    getTaskData();
  }

  fethData() async {
    setState(() {
      isLoading = true;
    });
    await Future.wait([getProjectData(), getTaskData()]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getProjectData() async {
    try {
      ListContainer projectNameList =
          await databaseMethods.matchAndRetrieve(widget.id);
      setState(() {
        assignedProjectNameList = projectNameList.list1;
      });

      if (assignedProjectNameList.isNotEmpty) {
        ListView.builder(
          itemCount: assignedProjectNameList.length,
          itemBuilder: (context, index) {},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No users assigned to this project.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  Future<void> getTaskData() async {
    try {
      ListContainer taskNameList =
          await databaseMethods.matchAndRetrieve(widget.id);
      setState(() {
        assignedTaskNameList = taskNameList.list2;
      });

      if (assignedTaskNameList.isNotEmpty) {
        ListView.builder(
          itemCount: assignedProjectNameList.length,
          itemBuilder: (context, index) {},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No users assigned to this project.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  value: null,
                  strokeWidth: 2.0,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Assigned Projects",
                            style: GoogleFonts.fredoka(
                              fontSize: 18.sp,
                            )),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: assignedProjectNameList.length,
                          itemBuilder: (context, index) {
                            String projectName = assignedProjectNameList[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        radius: 10.r,
                                        child: Text(
                                          '${index + 1}',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        projectName,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text("Assigned Tasks",
                          style: GoogleFonts.fredoka(
                            fontSize: 18.sp,
                          )),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: assignedTaskNameList.length,
                        itemBuilder: (context, index) {
                          dynamic name = assignedTaskNameList[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      radius: 10.r,
                                      child: Text(
                                        '${index + 1}',
                                        style: GoogleFonts.fredoka(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: GoogleFonts.fredoka(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  )),
                ],
              ),
            ),
    );
  }
}
