import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:task_management_tool/service/database.dart';
import 'package:readmore/readmore.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final projectNameController = TextEditingController();
  final projectDescController = TextEditingController();
  Stream? employeeStream;

  void clearText() {
    projectNameController.clear();
    projectDescController.clear();
  }

  getontheload() async {
    employeeStream = await DatabaseMethods().getProjectDetails();
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
          "Projects",
          style: GoogleFonts.fredoka(fontSize: 34, fontWeight: FontWeight.w600),
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
          Icons.library_add,
          color: Colors.white,
          size: 29,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  //---------------------------------CUSTOM WIDGETS------------------------------------

  Widget containerCard({
    String? projectName,
    String? projectDesc,
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
                                projectNameController.text = ds["Project_Name"],
                                projectDescController.text = ds["Project_Desc"],
                                editProjectDeatils(ds["ID"])
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) => DatabaseMethods()
                                  .deleteProjectDetail(ds["ID"]),
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
                                      child: Text(ds["Project_Name"],
                                          style: GoogleFonts.fredoka(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                                ReadMoreText(
                                  "Description:- " + ds["Project_Desc"],
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  lessStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                                  moreStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                                  trimCollapsedText: "readmore",
                                  trimExpandedText: "readless",
                                  style: TextStyle(color: const Color.fromARGB(255, 145, 143, 143)),
                                ),
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
                          projectName: "Project Name:- " + ds["Project_Name"],
                          projectDesc:
                              "Project Description:- " + ds["Project_Desc"],
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

  Future editProjectDeatils(String id) => showDialog(
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
                            child: Text("Edit Project Details",
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
                        textCapitalization: TextCapitalization.characters,
                        controller: projectNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: projectDescController,
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
                            "Project_Name": projectNameController.text,
                            "Project_Desc": projectDescController.text,
                            "ID": id
                          };
                          await DatabaseMethods()
                              .updateProjectDetails(id, updateInfo)
                              .then((onValue) {
                                clearText();
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
                  child: Text("Add Project",
                  //overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fredoka(
                          fontSize: 30.sp, fontWeight: FontWeight.w400)),
                ),
                // const Spacer(),
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
                    textCapitalization: TextCapitalization.characters,
                    controller: projectNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Project Name',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: projectDescController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Project Description',
                      hintStyle: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String id = randomAlpha(3);
                      Map<String, dynamic> employeeInfoMap = {
                        "Project_Name": projectNameController.text,
                        "Project_Desc": projectDescController.text,
                        "ID": id,
                      };
                      await DatabaseMethods()
                          .addProjectDetails(employeeInfoMap, id);
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
