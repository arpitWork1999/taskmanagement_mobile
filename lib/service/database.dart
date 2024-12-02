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

  Stream<QuerySnapshot> getUserDetails() {
    return _firestore.collection('Project').snapshots();
  }

  //-----------------------------------------PROJECT FUNCTIONS------------------------------
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

  //***************************TASK FUNCTIONS******************************************************
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

  //-----------------------------------Assigned User list-----------------------------
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic fieldValue = '';

Future<List<Map<String,dynamic>>> fetchDocumentData(String documentId) async {
  List<Map<String,dynamic>> userList = [];
  try {
    DocumentSnapshot document =
        await _firestore.collection('Project').doc(documentId).get();

    if (document.exists) {
      List<dynamic> fieldValue = document['AssignedUsers']; // Assuming it's a list
      print("OUTPUT----->>>>>> $fieldValue");

      // Loop through the list of IDs and fetch user data for each
      for (String userId in fieldValue) {
         Map<String,dynamic> userData =  await fetchUsersData(userId);
         userList.add(userData);
      }
      return userList;
    } else {
      return [];
      print("Document not found");
    }
  } catch (e) {
    return [];
    print("Error fetching document: $e");
  }

}

Future<Map<String,dynamic>> fetchUsersData(String userId) async {
  try {
    DocumentSnapshot document =
        await _firestore.collection('User').doc(userId).get();
    if (document.exists) {
    
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      return userData;
       print(userData); // Print user data
      // return document.data();
     
    } else {
      return {};
      print("User document not found for ID: $userId");
    }
  } catch (e) {
    return {};
    print("Error fetching user data: $e");
  }
}

}

 






  


