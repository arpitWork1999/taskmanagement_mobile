import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:task_management_tool/widgets/custom_navigator.dart';
import 'package:task_management_tool/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailText = TextEditingController();
    final passText = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool showSpinner = false;

  void clearText() {
    emailText.clear();
    passText.clear();
  }

  String extractErrorMessage(dynamic error) {
  String errorString = error.toString();

  // Customize logic to extract desired part of the message
  if (errorString.contains(']')) {
    return errorString.split(']').last.trim();
  }
  return "An error occurred"; // Default message
}

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/pngwing.com copy.png",
                    height: 35,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Sign up to continue",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: emailText,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(7),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.h)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.h, color: Colors.blue)))),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passText,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(7),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.h)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.h, color: Colors.blue)))),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email ?? "", password: password ?? "");
                        if (newUser != null) {
                          Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                           clearText();
                        }
                      } catch (e) {
                         String errorMessage = extractErrorMessage(e);
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage.toString())),
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(
                            MediaQuery.sizeOf(context).height * 0.4,
                            MediaQuery.sizeOf(context).width * 0.12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'By signing up, I accept the Atlassian ',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 107, 105, 105),
                          fontSize: 12.sp),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Cloud Terms of Service',
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.sp),
                        ),
                        TextSpan(
                          text: ' and acknowledge the ',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 107, 105, 105),
                              fontSize: 12.sp),
                        ),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Or continue with:",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      CustomLogoButton(
                          ImagePath: "assets/images/google.svg",
                          Name: "Google"),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomLogoButton(
                          ImagePath: "assets/images/microsoft.svg",
                          Name: "Microsoft"),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomLogoButton(
                          ImagePath: "assets/images/apple.svg", Name: "Apple"),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomLogoButton(
                          ImagePath: "assets/images/slack.svg", Name: "slack"),
                    ],
                  ),

                  // const SizedBox(height: 20),

                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(),
                  const SizedBox(height: 15),
                  SvgPicture.asset(
                    "assets/images/atlassian.svg",
                    height: MediaQuery.sizeOf(context).height * 0.033,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Privacy Policy  .  User Notice",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 107, 105, 105),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'This site is protected by reCAPTCHA and the Google ',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 107, 105, 105),
                          fontSize: 12.sp),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.sp),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 107, 105, 105),
                              fontSize: 12.sp),
                        ),
                        TextSpan(
                          text: 'Terms of Service ',
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 12.sp),
                        ),
                        TextSpan(
                          text: ' apply.',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 107, 105, 105),
                              fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// rfghkjwergbdbckj

  Widget CustomLogoButton({String? ImagePath, String? Name}) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.05,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent, border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SvgPicture.asset(
            ImagePath ?? "",
            height: 25,
          )),
          const SizedBox(
            width: 10,
          ),
          Text(
            Name ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
