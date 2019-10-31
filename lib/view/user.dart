import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:storebook/helper/api.dart';
import 'package:storebook/helper/myNavigation.dart';
import 'package:storebook/helper/myToast.dart';
import 'package:storebook/model/users.dart';
import 'package:http/http.dart' as http;
import 'package:storebook/plugin/sweetalert/sweetalert.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final listUser = List<ModelUsers>();
  bool loading = false;
  bool isThere = false;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  _delete(String id) async{
    try {
      final response = await http.delete(
        Api.deleteUser + id
      );
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        int value = data['value'];
        String pesan = data['message'];
        if (value == 1 ) {
          if (!mounted) return;
          setState(() {
            _viewUser();
          });
          Navigator.of(context, rootNavigator: true).pop();
          SweetAlert.show(context,subtitle: pesan, style: SweetAlertStyle.success);
          Timer(Duration(seconds: 1), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
          debugPrint(pesan);
        } else {
          debugPrint(pesan);
          toast(pesan);
        }
      }
      else {
        SweetAlert.show(context,subtitle: "Gagal", style: SweetAlertStyle.error);
      }
    }
    on SocketException catch (_) {
      SweetAlert.show(context,subtitle: 'tidak ada koneksi', style: SweetAlertStyle.error);
    }

  }

  _dialogDelete(String id, String fullname) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(16),
            shrinkWrap: true,
            children: <Widget>[
              Text('Apakah kamu yakin akan menghapus pengguna "' + fullname + '" ?' ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: OutlineButton(
                      onPressed: null,                      
                      color: Colors.black,
                      child: Text('Batal', style: TextStyle(color: Colors.black),),
                    )
                  ),
                  InkWell(
                    onTap: (){_delete(id);},
                    child: MaterialButton(
                      disabledColor: Colors.red,
                      onPressed: null,
                      color: Colors.red,
                      child: Text('Hapus', style: TextStyle(color: Colors.white),),
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

  Future<void> _viewUser() async {
    listUser.clear();
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    final response = await http.get(Api.viewUser);
    if (response.contentLength == 2 ){
      if (!mounted) return;      
      setState(() {
        loading = false;
        isThere = true;
      });
    }
    else{
      final data = jsonDecode(response.body);
      data.forEach((api){
        final ab = new ModelUsers(
          api['id'].toString(),
          api['fullname'],
          api['email'],
          api['password'],
          api['role'],
        );
        listUser.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false; 
      });
    }
  }
  
  PreferredSizeWidget _appBar(){
    return AppBar(
      elevation: 0,
      title: Text('Kelola pengguna'),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RefreshIndicator(
            onRefresh: _viewUser,
            key: _refresh,
            child: loading ? Center(child: CircularProgressIndicator()) : isThere ? Center(
            child: Text('belum ada pengguna', style: TextStyle(color: Colors.red),)) :
            ListView.builder(
              itemCount: listUser.length,
              itemBuilder: (context, i){
                final x = listUser[i];
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/img/avatar.jpg'),
                            radius: 40,
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(child: Text(x.fullname, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500 ))),
                                Text(x.email, style: TextStyle(fontSize: 14, )),
                                x.role == "1" ? Text("( Karyawan )", style: TextStyle(fontSize: 14, )) : Text("( Admin )", style: TextStyle(fontSize: 14, )),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              // IconButton(
                              //   icon: Icon(Icons.edit),
                              //   onPressed: (){},
                              // ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: (){ _dialogDelete(x.id, x.fullname);},
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ) ,
                );
              }
            ),
          ),
        ]
      );
  }

  @override
  void initState() {
    super.initState();
    _viewUser();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        popToDashboard(context);
        return false;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 10,
          child: Icon(
            Icons.add, color: Colors.white,
          ),
          onPressed: () => MyNavigator.goToFormUser(context)
        ),
      ),
    );
  }
}