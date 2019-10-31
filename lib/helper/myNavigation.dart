import 'package:flutter/material.dart';

class MyNavigator {
  static void goToDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/dashboard");
  }
  static void goToDashboard2(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false); 
  }
  static void goToIntro(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/intro");
  }
  static void goToAbout(BuildContext context) {
    Navigator.of(context).pushNamed("/about");
  }
  static void goToBook(BuildContext context) {
    Navigator.of(context).pushNamed("/book");
  }
  static void goToFormBook(BuildContext context) {
    Navigator.of(context).pushNamed("/addBook");
  }
  static void goToFormUser(BuildContext context) {
    Navigator.of(context).pushNamed("/addUser");
  }
  static void goToUser(BuildContext context) {
    Navigator.of(context).pushNamed("/user");
  }
  static void goToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/login");
  }
  static void goToLoginMenuPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/login/menu");
  }
  static void goToLoginMenuPage2(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login/menu', (Route<dynamic> route) => false); 
  }
}

Future<void> popToDashboard(BuildContext context) {
  return Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false); 
}