import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:lognsignup/home.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .set(employeeInfoMap);
  }

  //getEmployeeDetails() {}
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection("User").snapshots();
  }

  Future updateEmployeeDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .update(updateInfo);
  }
  Future deleteEmployeeDetail(
      String id) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id).delete();
  }
  //----------------projects----------------- 
  Future addProjectDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Project")
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProjectDetails() async {
    return await FirebaseFirestore.instance.collection("Project").snapshots();
  }
}