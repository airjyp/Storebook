import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:storebook/helper/api.dart';
import 'package:storebook/helper/myToast.dart';
import 'package:storebook/helper/validator.dart';
import 'package:storebook/plugin/sweetalert/sweetalert.dart';

class FormUsers extends StatefulWidget {
  @override
  _FormUsersState createState() => _FormUsersState();
}

class _FormUsersState extends State<FormUsers> {
  bool _autovalidate = false;
    bool _secureText = true;
  String fullname = "", email = "", password = "", role = "";
  TextEditingController txtFullname, txtEmail, txtPassword, txtRole;
  final _key = new GlobalKey<FormState>();
  
  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      toast("sedang diproses");
      _addUsers();
    }
    else{
      if (!mounted) return;
      setState(() {
       _autovalidate = true; 
      });
    }
  }

  _addUsers() async{
    if (!mounted) return;
    SweetAlert.show(context,subtitle: "Sedang memproses...", style: SweetAlertStyle.loading);
    try {
      final response = await http.post(
        Api.addUser,
        body: {
          "fullname" : fullname,
          "email" : email,
          "password" : password,
          "role" : role,
        }
      );
    
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        int value = data['value'];
        String pesan = data['message'];
        if (value == 1){ 
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.success);
          Timer(Duration(seconds: 1), () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pushReplacementNamed('/user'); 
          });
        } 
        else{
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.error);
        }
      }
      else{
          SweetAlert.show(context,subtitle: "Gagal", style: SweetAlertStyle.error);
      }
    }
    on SocketException catch (_) {
      SweetAlert.show(context,subtitle: "Cek koneksi internet anda", style: SweetAlertStyle.error);      
    }
  }
  
  PreferredSizeWidget _appBar(){
    return AppBar(
      elevation: 0,
      title: Text('Tambah Karyawan'),
      centerTitle: true,
    );
  }

  Widget _fullname(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only( top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtFullname,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(40),
              ],
              validator: Validator.fullname,
              onSaved: (e) => fullname = e,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan nama karyawan',
                labelText: 'Nama',
                icon: Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _email(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only( top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtEmail,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(40),
              ],
              keyboardType: TextInputType.emailAddress,
              validator: Validator.email,
              onSaved: (e) => email = e,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan email',
                labelText: 'Email',
                icon: Icon(CupertinoIcons.mail),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _password(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only( top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtPassword,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(40),
              ],
              validator: Validator.password,
              obscureText: _secureText,
              onSaved: (e) => password = e,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan password',
                labelText: 'Password',
                icon: Icon(CupertinoIcons.padlock),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _role(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtRole,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(1),
              ],
              keyboardType: TextInputType.number,
              validator: Validator.role,
              onSaved: (e) => role = e,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan role',
                labelText: 'Role',
                icon: Icon(CupertinoIcons.group),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formUser() {
    return Form(
      autovalidate: _autovalidate,
      key: _key,
      child: new Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
            children: <Widget> [ 
              Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height:20), _fullname(),
                    SizedBox(height:10), _email(),
                    SizedBox(height:10), _password(),
                    SizedBox(height:10), _role(),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _submit(){
    return Container(
      child : MaterialButton(
        height: 50,
        elevation: 10,
        color: Colors.blue,
        onPressed: (){ check(); },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Simpan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _formUser(),
      bottomNavigationBar: BottomAppBar(
        child: _submit()
      )
    );
  }
}