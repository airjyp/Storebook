import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:storebook/helper/myNavigation.dart';

class Intro {
  String image;
  String title;
  String description;
  
  Intro({this.image, this.title, this.description});
}

class ColorPalette {
  static const dotColor = Color(0xffe8e8e8);
  // static const dotActiveColor = Color(0xffff3800);
  static const dotActiveColor = Colors.blue;
  static const titleColor = Colors.blue;
  static const descriptionColor = Color(0xff707070);
}

class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() {
    return IntroPageState();
  }
}

class IntroPageState extends State<IntroPage> {

  final List<Intro> introList = [
    Intro(
      image: "assets/intro/welcome.jpg",
      title: 'Selamat Datang !',
      description: 'STOREBOOK merupakan aplikasi yang memberikan kemudahan untuk pencatatan barang yang baru masuk pada Toko',
    ),
    Intro(
      image: "assets/intro/manage.gif",
      title: 'Ayo mulai !',
      description: 'Gunakan aplikasi Storebook untuk mengelola pencatatan pada Toko anda sekarang',
    ),
  ]; 

  List<Widget> _buildPage(BuildContext context) {
    List<Widget> widgets = [];
    for(int i=0; i < introList.length; i++) {
      Intro intro = introList[i];
      widgets.add(
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height/6,
          ),
          child: ListView(
            children: <Widget>[
              Image.asset(
                intro.image,
                height: MediaQuery.of(context).size.height/3.5,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/12.0,
                ),
              ),
              Center(
                child: Text(
                  intro.title,
                  style: TextStyle(
                    color: ColorPalette.titleColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/20.0,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height/20.0,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      intro.description,
                      style: TextStyle(
                        color: ColorPalette.descriptionColor,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    i == introList.length - 1 ? 
                    ListBody(
                      children: <Widget>[
                        SizedBox(height: 20),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: InkWell(
                            onTap: () => MyNavigator.goToLoginMenuPage(context),
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                              size : 30
                            ),
                          ) 
                        ),
                        
                      ],
                    )
                    : 
                    Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Swiper.children(
            index: 0,
            autoplay: false,
            loop: false,
            pagination: SwiperPagination(
              margin: EdgeInsets.only(bottom: 20.0),
              builder: DotSwiperPaginationBuilder(
                color: ColorPalette.dotColor,
                activeColor: ColorPalette.dotActiveColor,
                size: 10.0,
                activeSize: 10.0,
              ),
            ),
            control: SwiperControl(
              iconNext: null,
              iconPrevious: null
            ),
            children: _buildPage(context),
          ),
        ],
      ),
    );
  }
}
