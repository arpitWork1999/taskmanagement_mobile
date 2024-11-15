import 'package:flutter/material.dart';

class NavigationService {
  //Navigator.push implemented here
  static Future<dynamic> navigateTo(Widget page, BuildContext context,
      {isTransition = true}) {
    return isTransition
        ? Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => page,
              transitionDuration: const Duration(milliseconds: 60),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          )
        : Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return page;
            },
          ));
  }

  //Navigator.pushReplacement implemented here
  static Future<dynamic> navigateToReplacement(
      Widget page, BuildContext context) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  //to finish current page and move to back screen
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  //Navigator.pushReplacement implemented here with arguments
  static Future<dynamic> navigateWithArgs(
      BuildContext context, Widget page, Object arguments) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(arguments: arguments)),
    );
  }

  static Future<dynamic> pushAndRemoveUntil(
      Widget page,

    BuildContext context,
  ) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page), (Route route) => false);
  }
}
