import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storebook/helper/api.dart';
import 'package:storebook/helper/myNavigation.dart';
import 'package:storebook/helper/validator.dart';
import 'package:storebook/plugin/sweetalert/sweetalert.dart';



enum LoginStatus{
  notSignIn,
  signIn
}

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  LoginStatus loginStatus = LoginStatus.notSignIn;
  bool _autovalidate = false;
  bool _secureText = true;
  bool loading = false;
  String email;
  String password; 
  String role;
  final _key = new GlobalKey<FormState>();

  _tryToPop(context) async {
    MyNavigator.goToLoginMenuPage(context);
  }

  _check(){
    final form= _key.currentState;
    if(form.validate()){
      form.save();
      _login();
    }
    else{
      if (!mounted) return;
      setState(() {
       _autovalidate = true; 
      });
    }
  }

  _getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      role = preferences.getString("role");
      loginStatus = role == null || role == '' ? LoginStatus.notSignIn 
      : LoginStatus.signIn;
    });
  }

  _login() async{
    if (!mounted) return;
    SweetAlert.show(context,subtitle: "Sedang memproses...", style: SweetAlertStyle.loading);
    try {
      final response = await http.post(
        Api.login, body: {
        "email" : email,
        "password" : password,
        }
      );
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        int value = data['value'];
        String pesan = data['message'];
        String emailAPI = data['email'];
        String fullnameAPI = data['fullname'];
        String id = data['id'].toString();
        String role = data['role'];
        
        if (value == 1){
          _savePref(value, emailAPI, fullnameAPI, id, role);
          if (!mounted) return;
          setState(() {
            loginStatus = LoginStatus.signIn;
          });
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.success);
          Timer(Duration(seconds: 1), () {
            MyNavigator.goToDashboard2(context);
          });
        }
        else if (value == 4){ //salah password
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.error);
        }
        else if (value == 5){ //email tidak terdaftar
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.confirm);      
        }
        else { //login gagal
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.error);      
        }
      }
      else {
        SweetAlert.show(context,subtitle: "Gagal", style: SweetAlertStyle.error);      
      }
    } 
    on SocketException catch (_) {
      SweetAlert.show(context,subtitle: "Cek koneksi internet anda", style: SweetAlertStyle.error);      
    }
    
  }
  
  _savePref(int value, String email, String fullname, String id, String role) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("fullname", fullname);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.setString("role", role);
    });
  }

  _showHide(){
    if (!mounted) return;
    setState((){
      _secureText = !_secureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPref();

  }

  Widget _logo(){
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/img/storebook-blue.png'),                                  
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Text(
              'STOREBOOK',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0),
            )
          ],
        ),
      ),
    ]
  );
}

  Widget _fieldEmail(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              inputFormatters: [
                new LengthLimitingTextInputFormatter(40),
              ],
              keyboardType: TextInputType.emailAddress,
              validator: Validator.email,
              onSaved: (e)=> email = e,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.7), width: 0.0), borderRadius: BorderRadius.circular(20)
                ),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(20)),
                hintText: 'Masukkan surel / email',
                labelText: 'Surel / email ',
                prefixIcon: Icon(CupertinoIcons.mail),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldPassword(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              inputFormatters: [
                new LengthLimitingTextInputFormatter(20),
              ],
              validator: Validator.passwordLogin,
              obscureText: _secureText,
              onSaved: (e)=>password = e,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.7), width: 0.0), borderRadius: BorderRadius.circular(20)
                ),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                suffixIcon: IconButton(
                  onPressed: _showHide,
                  icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Masukkan kata sandi',
                labelText: 'Kata sandi',
                prefixIcon: Icon(CupertinoIcons.padlock),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bagianTombol(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: new FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              onPressed: () { _check(); },
              child: new Container(
                padding: EdgeInsets.all(0),
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
    );
  }

  Widget _formLogin() {
    return Form(
      autovalidate: _autovalidate,
      key: _key,
        child: new Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[ 
            new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60),
              _logo(),
              SizedBox(height: 25),
              _fieldEmail(),
              SizedBox(height: 15),
              _fieldPassword(),
              SizedBox(height: 15),
              _bagianTombol(),
            ],
          ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () => _tryToPop(context),
      child: Scaffold(
        body: _formLogin(),
      ),
    );
  }
}