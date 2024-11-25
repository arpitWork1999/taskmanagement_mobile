import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management_tool/homepage.dart';
// import 'package:task_management_tool/login_screen.dart';
// import 'package:task_management_tool/main_screen.dart';
// import 'package:task_management_tool/projects_screen.dart';
// import 'package:task_management_tool/signup_screen.dart';
// import 'package:task_management_tool/tasks_screen.dart';

Future main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
 
 );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      
      builder: (_ , child) {
        return  const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          //home: ProjectScreen(),
          //home:TaskScreen()
          //home: MainScreen(),
          home: Homepage(),
          );
  });

}}