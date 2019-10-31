import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:storebook/helper/api.dart';
import 'package:storebook/helper/myNavigation.dart';
import 'package:storebook/model/book.dart';
import 'package:http/http.dart' as http;

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  final listBook = List<ModelBook>();
  bool loading = false;
  bool isThere = false;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _viewBook() async {
    listBook.clear();
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    final response = await http.get(Api.viewBook);
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
        final ab = new ModelBook(
          api['id'].toString(),
          api['name'],
          api['quantity'],
          api['supplier'],
          api['date'],
        );
        listBook.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false; 
      });
    }
  }

  Widget _body() {
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RefreshIndicator(
            onRefresh: _viewBook,
            key: _refresh,
            child: loading ? Center(child: CircularProgressIndicator()) : isThere ? Center(
            child: Text('belum ada catatan', style: TextStyle(color: Colors.red),)) :
            ListView.builder(
              itemCount: listBook.length,
              itemBuilder: (context, i){
                final x = listBook[i];
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Image.asset('assets/img/image.jpg', height: 100, width: 100,),
                          SizedBox(width: 20,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(child: 
                                Text('Nama barang: ' + x.name, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500 ))),
                                Text('Jumlah: ' + x.quantity, style: TextStyle(fontSize: 14, )),
                                Text('Supplier: ' + x.supplier, style: TextStyle(fontSize: 14, )),
                                Text('Tanggal masuk: ' + x.date, style: TextStyle(fontSize: 14, )),
                              ],
                            ),
                          ),
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
    _viewBook();
  }

  PreferredSizeWidget _appBar(){
    return AppBar(
      elevation: 0,
      title: Text('Buku catatan toko'),
      centerTitle: true,
    );
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
          onPressed: () => MyNavigator.goToFormBook(context)
        ),
      ),
    );
  }

}