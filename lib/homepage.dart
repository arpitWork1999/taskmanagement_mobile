import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management_tool/login_screen.dart';
import 'package:task_management_tool/signup_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final List<String> imgList = [
    "assets/images/first.png",
    "assets/images/second.png",
    "assets/images/third.png",
    "assets/images/fourth.png",
    "assets/images/fifth.png"
  ];
  int _currentIndex = 0;

  final List<Widget> imageSliders = [
    "assets/images/first.png",
    "assets/images/second.png",
    "assets/images/third.png",
    "assets/images/fourth.png",
    "assets/images/fifth.png"
  ]
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    item,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 40.h,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                    aspectRatio: 1.5,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = entry.key),
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        margin: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    "Plan and track tasks, bugs, support tickets, and more.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(250.h, 45.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.white),
                      backgroundColor: Colors.transparent,
                      minimumSize: Size(250.h, 45.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Wrap(
                  children: [
                    Center(
                      child: Text(
                        "By signing up, you agree to the",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "User Notice and Privact Policy.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Can't log in or sign up?",
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
