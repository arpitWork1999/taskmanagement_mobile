import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

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

  Future deleteEmployeeDetail(String id) async {
    return await FirebaseFirestore.instance.collection("User").doc(id).delete();
  }

  //-----------------------------------------PROJECT FUNCTION------------------------------
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


  Future updateProjectDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Project")
        .doc(id)
        .update(updateInfo);
  }

  Future deleteProjectDetail(String id) async {
    return await FirebaseFirestore.instance
        .collection("Project")
        .doc(id)
        .delete();
  }

  //***************************TASK FUNCTION******************************************************
  Future addTaskDetails(Map<String, dynamic> employeeInfoMap, String id) async {
    copyAssignedUsers(
        employeeInfoMap['AssignedProject'], employeeInfoMap['AssignedUsers']);
    return await FirebaseFirestore.instance
        .collection("Task")
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<void> copyAssignedUsers(
      String projectID, List<dynamic> assignedUsers) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Project')
              .doc(projectID)
              .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();
        if (data != null) {
          List<dynamic> userList = data['AssignedUsers'];
          List<dynamic> combinedList =
              [...userList, ...assignedUsers].toSet().toList();
          await FirebaseFirestore.instance
              .collection('Project')
              .doc(projectID)
              .update({'AssignedUsers': combinedList});
        }
      }
    } catch (e) {
      print('Error fetching field: $e');
    }
  }
//***************************TASK FUNCTION******************************************************

  Future<Stream<QuerySnapshot>> getTaskDetails() async {
    return await FirebaseFirestore.instance.collection("Task").snapshots();
  }

  Future updateTaskDetails(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Task")
        .doc(id)
        .update(updateInfo);
  }

  Future deleteTaskDetail(String id) async {
    return await FirebaseFirestore.instance.collection("Task").doc(id).delete();
  }

  //--------------------------DROPDOWN TEXTFIELDS FUNCTION----------------------------

  static Future<List<DropDownValueModel>> fetchSpecificFields() async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('Project');
      QuerySnapshot querySnapshot = await collectionRef.get();
      List<DropDownValueModel> dropDownList = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return DropDownValueModel(
          name: data['Project_Name'] ?? 'Unknown',
          value: data['ID'] ?? '',
        );
      }).toList();

      return dropDownList;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  static Future<List<DropDownValueModel>> fetchDropDownValues() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('User').get();
    List<DropDownValueModel> dropDownValues = snapshot.docs.map((doc) {
      return DropDownValueModel(
        name: doc['Name'] ?? '',
        value: doc['ID'] ?? '',
      );
    }).toList();

    return dropDownValues;
  }
}
