import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:random_string/random_string.dart';
import 'package:task_management_tool/service/database.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final taskNameController = TextEditingController();
  final moduleNameController = TextEditingController();
  final cnt = SingleValueDropDownController();
  final cntMulti = MultiValueDropDownController();

  List<DropDownValueModel> projectDropdownValues = [];
  List<DropDownValueModel> userDropDownValues = [];

  Stream? employeeStream;
  String projectId = '';
  List<dynamic> selectedUsers = [];

  getontheload() async {
    employeeStream = await DatabaseMethods().getTaskDetails();
    setState(() {});
  }

  void clearText() {
    taskNameController.clear();
    moduleNameController.clear();
    cnt.clearDropDown();
    cntMulti.clearDropDown();
  }

  @override
  void initState() {
    super.initState();
     getontheload();
    getProjectList();
    getUserList();
  }

  getProjectList() async {
    try {
      List<DropDownValueModel> fetchedValues =
          await DatabaseMethods.fetchSpecificFields();
      setState(() {
        projectDropdownValues = fetchedValues;
      });
    } catch (e) {
      print("Error fetching project list: $e");
    }
  }

  getUserList() async {
    try {
      List<DropDownValueModel> userFetchedValues =
          await DatabaseMethods.fetchDropDownValues();
      setState(() {
        userDropDownValues = userFetchedValues;
      });
    } catch (e) {
      print("Error fetching project list: $e");
    }
  }

  void onItemChanged(List<DropDownValueModel> value) {
    List<dynamic> usersIds = value.map((item) => item.value).toList();
    setState(() {
      selectedUsers = usersIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: GoogleFonts.fredoka(fontSize: 34, fontWeight: FontWeight.w600),
        ),
      ),
      body: containerCard(),
      //body: const Center(child: Text("Oops! there is no task here...")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customDilogbox(context);
        },
        backgroundColor: Colors.black,
        elevation: 5,
        splashColor: Colors.grey,
        child: const Icon(
          Icons.add_task,
          color: Colors.white,
          size: 29,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  //-------------------------------CUSTOM WIDGETS----------------------------------

 Widget containerCard({
    String? taskName,
    String? moduleName,
    // String? AssignedProject,
    // String? AssignedUsers
  }) {
    return StreamBuilder(
        stream: employeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 9, 10, 1),
                      child: Slidable(
                        key: const ValueKey(0),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => {
                                taskNameController.text = ds["TaskName"],
                                moduleNameController.text = ds["ModuleName"],
                                editTaskDetails(ds["ID"])
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) => DatabaseMethods()
                                  .deleteTaskDetail(ds["ID"]),
                              backgroundColor: const Color.fromARGB(255, 231, 55, 55),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(ds["TaskName"],
                                          style: GoogleFonts.fredoka(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                                Text(ds["ModuleName"],
                                          style: GoogleFonts.fredoka(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: const BoxDecoration(color: Colors.black),
                );
        });
  }

Widget allTaskDetails() {
    return StreamBuilder(
        stream: employeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Column(
                      children: [
                        containerCard(
                          taskName:  ds["TaskName"],
                          moduleName:
                              ds["ModuleName"],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  },
                )
              : Container(
                  decoration: const BoxDecoration(color: Colors.black),
                );
        });
  }

Future editTaskDetails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.all(10), // Add padding to the container
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text("Edit Task Details",
                                style: GoogleFonts.fredoka(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w400)),
                          ),
                          GestureDetector(
                            onTap: () {
                              clearText();
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      TextField(
                        controller: taskNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: moduleNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ), 
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updateInfo = {
                            "TaskName": taskNameController.text,
                            "ModuleName": moduleNameController.text,
                            "ID": id
                          };
                          await DatabaseMethods()
                              .updateTaskDetails(id, updateInfo)
                              .then((onValue) {
                            Navigator.pop(context);
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.grey),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: Text(
                          "Save",
                          style: GoogleFonts.fredoka(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));

  void customDilogbox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Expanded(
                  child: Text("Add New Task",
                      style: GoogleFonts.fredoka(
                          fontSize: 30.sp, fontWeight: FontWeight.w400)),
                ),
                IconButton(
                  onPressed: () {
                    clearText();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                  ),
                )
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Task Name',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: moduleNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Module Name',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropDownTextField(
                    controller: cnt,
                    textFieldDecoration: InputDecoration(
                        hintText: "-Select Project-",
                        hintStyle: GoogleFonts.fredoka(
                          fontSize: 18.sp,
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(10))),
                    listSpace: 20,
                    listPadding: ListPadding(top: 20),
                    readOnly: true,
                    enableSearch: true,
                    validator: (value) {
                      if (value == null) {
                        return "Required field";
                      } else {
                        return null;
                      }
                    },
                    dropDownList: projectDropdownValues,
                    listTextStyle: const TextStyle(color: Colors.black),
                    dropDownItemCount: 4,
                    onChanged: (value) {
                      setState(() {
                        projectId = value.name;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropDownTextField.multiSelection(
                    controller: cntMulti,
                    textFieldDecoration: InputDecoration(
                        hintText: "-Select Users-",
                        hintStyle: GoogleFonts.fredoka(
                          fontSize: 18.sp,
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(10))),
                    checkBoxProperty: CheckBoxProperty(
                        fillColor: WidgetStateProperty.all<Color>(Colors.grey)),
                    dropDownList: userDropDownValues,
                    listTextStyle: const TextStyle(color: Colors.black),
                    dropDownItemCount: 3,
                    onChanged: (dynamic value) {
                      if (value != null) {
                        onItemChanged(
                            value); // Ensure this matches the expected type
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String id = randomAlpha(4);
                      Map<String, dynamic> employeeInfoMap = {
                        "TaskName": taskNameController.text,
                        "ModuleName": moduleNameController.text,
                        "AssignedUsers": selectedUsers,
                        "AssignedProject": projectId,
                        "ID": id,
                      };
                      await DatabaseMethods()
                          .addTaskDetails(employeeInfoMap, id);
                      clearText();
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.grey),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: Text(
                      "Save",
                      style: GoogleFonts.fredoka(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
