import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_tool/service/database.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

enum Actions { edit, delete }

class _UserScreenState extends State<UserScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final skillController = TextEditingController();
  Stream? employeeStream;

  void clearText() {
    nameController.clear();
    idController.clear();
    skillController.clear();
  }

  getontheload() async {
    employeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  initState() {
    getontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users",
          style: GoogleFonts.fredoka(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
      body: containerCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customDilogbox(context);
        },
        backgroundColor: Colors.black,
        elevation: 5,
        splashColor: Colors.grey,
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
          size: 29,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  //---------------------------------CUSTOM WIDGETS------------------------------------

  Widget containerCard({
    String? name,
    String? employeeCode,
    String? skill,
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
                                nameController.text = ds["Name"],
                                idController.text = ds["Employee_Code"],
                                skillController.text = ds["Skill"],
                                editEmployeeDeatils(ds["ID"])
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) => DatabaseMethods()
                                  .deleteEmployeeDetail(ds["ID"]),
                              backgroundColor: const Color.fromARGB(255, 231, 55, 55),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          color: const Color.fromARGB(255, 82, 169, 241),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('Name:- ${ds["Name"]}',
                                          style: GoogleFonts.fredoka(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                            
                                            CircleAvatar(radius: 15.r,backgroundImage: NetworkImage("https://avatar.iran.liara.run/public/boy?${index+1}"),)
                                  ],
                                ),
                                Text('Employee Code:- ${ds["Employee_Code"]}',
                                    style: GoogleFonts.fredoka(
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                                Text("Skill:- ${ds["Skill"]}",
                                    style: GoogleFonts.fredoka(
                                        fontSize: 21.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child:  SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                          value: null,
                          strokeWidth: 5.0,
                        ),
                      ),
                    ),
                   
                  ]
              );
        });
  }

  Widget allEmployeeDetails() {
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
                          name: "Name:- " + ds["Name"],
                          employeeCode: "Employee_Code:- " + ds["Email"],
                          skill: "Skill:- " + ds["Skill"],
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

  Future editEmployeeDeatils(String id) => showDialog(
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
                            child: Text("Edit Details",
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
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: skillController,
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
                            "Name": nameController.text,
                            "Employee_Code": idController.text,
                            "Skill": skillController.text,
                            "ID": id
                          };
                          await DatabaseMethods()
                              .updateEmployeeDetails(id, updateInfo)
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
                  child: Text("Add User",
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
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Name',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Employee Id',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: skillController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter TechStack',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    
                    onPressed: () async {
                      String id = randomAlpha(5);
                      Map<String, dynamic> employeeInfoMap = {
                        "Name": nameController.text,
                        "Employee_Code": idController.text,
                        "Skill": skillController.text,
                        "ID": id,
                      };
                      await DatabaseMethods()
                          .addEmployeeDetails(employeeInfoMap, id);
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
