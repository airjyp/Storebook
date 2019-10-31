import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storebook/helper/myNavigation.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      MyNavigator.goToLoginMenuPage(context);
    } else {
      prefs.setBool('seen', true);
      MyNavigator.goToIntro(context);
    }
}
  
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      _checkFirstSeen();
    });

  }

  Widget _body(){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: Colors.blue,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/img/storebook.png'),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'STOREBOOK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.0
                      ),
                    ),
                    Text(
                      'Aplikasi pencatatan barang pada Toko',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _body(),
    );
  }
}
