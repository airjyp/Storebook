import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'loginPage.dart';

enum LoginStatus{
  notSignIn,
  signIn
}

class LoginMenuPage extends StatefulWidget {
  @override
  _LoginMenuPageState createState() => _LoginMenuPageState();
}

class _LoginMenuPageState extends State<LoginMenuPage> with TickerProviderStateMixin {
  var role;  
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);

  //function
  _getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      role = preferences.getString("role");
      _loginStatus = role == null || role == '' ? LoginStatus.notSignIn 
      : LoginStatus.signIn;
    });
  }

  _gotoLogin() {
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _getPref();

  }
  
  Widget _loginMenuPage() {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/img/storebook.png'),                      
                      Padding(
                        padding: EdgeInsets.only(top: 20.0)
                      ),
                      Text(
                        'STOREBOOK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 90.0, right: 90.0, top: 0.0, bottom: 100),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new OutlineButton(
                        borderSide: BorderSide(color: Colors.white),
                        // splashColor: MyColors.abuabu,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () => _gotoLogin(),
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 0.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   return _loginStatus == LoginStatus.notSignIn ?
    Container(
      height: MediaQuery.of(context).size.height,
      child: PageView(
        controller: _controller,
        physics: new ClampingScrollPhysics(),
        children: <Widget>[LoginPage(), _loginMenuPage()],
        scrollDirection: Axis.horizontal,
      )
    ) :  Dashboard();
  }
}