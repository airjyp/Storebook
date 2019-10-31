import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PreferredSizeWidget _appBar(){
    return AppBar(
      elevation: 0,
      title: Text('Tentang'),
      centerTitle: true,
    );
  }

  Widget _body(context){
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenHeight / 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset('assets/img/storebook-blue.png'),                                  
                ],
              ),
              SizedBox(height: 25,),
              Text("STOREBOOK", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 24, fontWeight: FontWeight.w500),),
              SizedBox(height: 5,),                    
              Text("Versi 1.0.0", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 20.0),),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
    );
  }
}