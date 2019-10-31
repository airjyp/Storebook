import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storebook/helper/myNavigation.dart';
import 'package:storebook/helper/myToast.dart';
import 'package:storebook/plugin/sweetalert/sweetalert.dart';
import 'package:storebook/view/addBook.dart';
import 'package:storebook/view/book.dart';
import 'package:storebook/view/user.dart';

enum LoginStatus{
  notSignIn,
  signIn,
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool allowExit = false;
  String fullname= "";
  String email = "";
  String id = "";
  String role = "";
  LoginStatus loginStatus = LoginStatus.signIn;

  _getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      id = preferences.getString('id');
      fullname = preferences.getString('fullname');
      email = preferences.getString('email');
      role = preferences.getString('role');
    });
  }
  
  Future<bool> _tryToExit(context) async {
    if (allowExit) {
      return true;
    } else {
      allowExit = true;
      toast('Tekan tombol kembali lagi untuk keluar');
      Timer(Duration(seconds: 2), () {
        allowExit = false;
      });
    }
    return null;
  }

  _popupSignOut() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(16),
            shrinkWrap: true,
            children: <Widget>[
              Text('Apakah kamu yakin ingin keluar akun?'),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).pop();
                      debugPrint(id);
                    },
                    child: OutlineButton(
                      onPressed: null,
                      color: Colors.black,
                      child: Text('Batal', style: TextStyle(color: Colors.black),),
                    )
                  ),
                  InkWell(
                    onTap: (){ 
                      _signOut();
                    },
                    child: MaterialButton(
                      onPressed: null,
                      disabledColor: Colors.red,
                      color: Colors.red,
                      child: Text('Keluar', style: TextStyle(color: Colors.white),),
                    ) 
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  _signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("role", null);
      loginStatus = LoginStatus.notSignIn;
    });
    SweetAlert.show(context,subtitle: 'Berhasil keluar dari akun', style: SweetAlertStyle.success);      
    Timer(Duration(seconds: 1), () {
      Navigator.of(context, rootNavigator: true).pop();
      MyNavigator.goToLoginMenuPage2(context);
    });
  }

  Widget _buildMenu(BuildContext context, _color,  _icon, _text, _navigator){
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _navigator)),
      child: new Card(
        color: Colors.white,
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: new ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(color: _color,)
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Icon(_icon, color: Colors.white, size: 50,),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_text, style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
          ],
        )
      ),
    );
  }


  Widget _body(context){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GridView(
          padding: EdgeInsets.all(10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: <Widget> [
            _buildMenu(context, Colors.blue, Icons.book , 'Lihat buku catatan', Book()),
            _buildMenu(context, Colors.blue, Icons.add, 'Tambahkan barang', FormBook()),
            role == "0" ?_buildMenu(context, Colors.blue, Icons.people, 'Kelola pengguna', User()) : Container(),
          ]
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(){
    return AppBar(
      elevation: 0,
      title: Text('Dashboard'),
      centerTitle: true,
    );
  }

  Widget menuHome(title, icons, navigasi){ 
  return ListTile(
    onTap: navigasi,
    title: new Text(title, style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w300,)),
    leading: new Icon(icons, color: Colors.blue),
  );
}

Widget menu(title, icons, navigasi){ 
  return ListTile(
    onTap: navigasi,
    title: new Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,)),
    leading: new Icon(icons),
  );
}

  Widget _drawer(){
    return Drawer(
      child: new ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          new UserAccountsDrawerHeader(
            onDetailsPressed: (){
              // Navigator.pop(context); 
              // MyNavigator.rightToLeft(context, ProfilePage());
            },
            accountName: new Text(fullname, style: TextStyle(fontSize: 14, )),
            accountEmail: new Text(email, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/img/avatar.jpg')
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          menuHome('Dashboard', Icons.style, null),
          menu('Lihat buku catatan toko', Icons.book, () { Navigator.pop(context); MyNavigator.goToBook(context);}),
          menu('Tambahkan barang', Icons.add_box,() {  Navigator.pop(context); MyNavigator.goToFormBook(context);}),          
          role == "0" ? menu('Kelola pengguna', Icons.people, () { Navigator.pop(context); MyNavigator.goToUser(context);}) : Container(),
          Divider(),
          menu('Tentang', Icons.info_outline, () {  Navigator.pop(context); MyNavigator.goToAbout(context); }),
          menu('Keluar', Icons.exit_to_app, () { _popupSignOut();}),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getPref();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _tryToExit(context),
      child: Scaffold(
        appBar: _appBar(),
        drawer: _drawer(),
        backgroundColor: Colors.white,
        body: _body(context),
      ),
    );
  }
}