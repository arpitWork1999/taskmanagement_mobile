// import 'package:flutter/material.dart';

// class Rough extends StatefulWidget {
//   const Rough({super.key});

//   @override
//   State<Rough> createState() => _RoughState();
// }

// class _RoughState extends State<Rough> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Task List"),
//       ),
//       body: assignedTaskNameList.isEmpty
//           ? Center(
//               child: CircularProgressIndicator(), // Show a loader while data is being prepared
//             )
//           : ListView.builder(
//               itemCount: assignedTaskNameList.length,
//               itemBuilder: (context, index) {
//                 String name = assignedTaskNameList[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     child: Text('${index + 1}'),
//                   ),
//                   title: Text(
//                     name,
//                     style: GoogleFonts.fredoka(
//                       fontSize: 20,
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }