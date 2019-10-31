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
import 'package:intl/intl.dart';
import 'package:storebook/plugin/sweetalert/sweetalert.dart';

DateTime _datee = new DateTime.now();

class FormBook extends StatefulWidget {
  @override
  _FormBookState createState() => _FormBookState();
}

class _FormBookState extends State<FormBook> {
  bool _autovalidate = false;
  bool changedDate = false;
  DateTime picked2;
  String name = "", quantity = "", supplier = "", date = "";
  TextEditingController txtName, txtQuantity, txtSupplier, txtDate;
  final TextEditingController dateController = new TextEditingController();
  final _key = new GlobalKey<FormState>();
  
  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      toast("sedang diproses");
      _addBook();
    }
    else{
      if (!mounted) return;
      setState(() {
       _autovalidate = true; 
      });
    }
  }

  _addBook() async{
    if (!mounted) return;
    SweetAlert.show(context,subtitle: "Sedang memproses...", style: SweetAlertStyle.loading);
    try {
      final response = await http.post(
        Api.addBook,
        body: {
          "name" : name,
          "quantity" : quantity,
          "supplier" : supplier,
          "date" : date,
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
            Navigator.of(context).pushReplacementNamed('/book'); 
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
      title: Text('Tambah Barang'),
      centerTitle: true,
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: !changedDate ? DateTime(_datee.year, _datee.month, _datee.day) : picked2,
        firstDate: new DateTime(_datee.year, _datee.month-3, _datee.day),
        lastDate: new DateTime(_datee.year, _datee.month + 3, _datee.day),
    );
    if (picked != null) {
      setState(() {
        changedDate = true;
        picked2 = picked;
        String formattedDate2 = DateFormat('yyyy-MM-dd').format(picked);
        dateController.text = formattedDate2;
      });
    }
  }

  Widget _name(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only( top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtName,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(40),
              ],
              validator: Validator.name,
              onSaved: (e) => name = e,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan nama barang',
                labelText: 'Nama barang',
                icon: Icon(CupertinoIcons.tag),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _supplier(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only( top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtSupplier,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(40),
              ],
              validator: Validator.supplier,
              onSaved: (e) => supplier = e,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan nama pemasok',
                labelText: 'Pemasok',
                icon: Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantity(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              controller: txtQuantity,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(14),
              ],
              keyboardType: TextInputType.number,
              validator: Validator.quantity,
              onSaved: (e) => quantity = e,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                border: UnderlineInputBorder(),
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Masukkan jumlah barang',
                labelText: 'Jumlah barang',
                icon: Icon(CupertinoIcons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _date(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: InkWell(
              onTap: (){_selectDate();},
              child: IgnorePointer(
                child: TextFormField(
                  controller: dateController,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(100)
                  ],
                  validator: Validator.date,
                  onSaved: (e) => date = e,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 0, bottom: 15),
                    border: UnderlineInputBorder(),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'Masukkan tanggal input',
                    labelText: 'Tanggal',
                    icon: Icon(Icons.date_range),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formBook() {
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
                    SizedBox(height:20), _name(),
                    SizedBox(height:10), _quantity(),
                    SizedBox(height:10), _supplier(),
                    SizedBox(height:10), _date(),
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
      body: _formBook(),
      bottomNavigationBar: BottomAppBar(
        child: _submit()
      )
    );
  }
}