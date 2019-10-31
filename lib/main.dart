import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storebook/view/about.dart';
import 'package:storebook/view/addBook.dart';
import 'package:storebook/view/addUsers.dart';
import 'package:storebook/view/book.dart';
import 'package:storebook/view/dashboard.dart';
import 'package:storebook/view/intro.dart';
import 'package:storebook/view/loginMenu.dart';
import 'package:storebook/view/loginPage.dart';
import 'package:storebook/view/user.dart';
import 'package:storebook/view/splash.dart';

var defineRoutes = <String, WidgetBuilder>{
  "/dashboard": (BuildContext context) => Dashboard(),
  "/intro": (BuildContext context) => IntroPage(),
  "/login": (BuildContext context) => LoginPage(),
  "/login/menu": (BuildContext context) => LoginMenuPage(),
  "/about": (BuildContext context) => AboutPage(),
  "/book": (BuildContext context) => Book(),
  "/addBook": (BuildContext context) => FormBook(),
  "/addUser": (BuildContext context) => FormUsers(),
  "/user": (BuildContext context) => User(),

};

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: true,
        title: "Storebook",
        home: SplashScreen(),
        routes: defineRoutes,
        theme: ThemeData(
          fontFamily: 'GoogleSans',
          primaryColor: Colors.blue,
          accentColor: Colors.blue,
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
      )
    );
  });
}