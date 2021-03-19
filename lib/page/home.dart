import 'package:final_task/crud/keranjang.dart';
import 'package:final_task/page/crud.dart';
import 'package:final_task/page/get.dart';
import 'package:final_task/page/profil.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const router = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nama = '';
  int _page = 0;
  GlobalKey bottomkey = GlobalKey();
  final List<Widget> screens = [Get(), Crud(), Keranjang()];

  Widget tampilScreen = Get();

  @override
  void initState() {
    getPref();
    super.initState();
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffa7bb9f),
          title: Row(
            children: <Widget>[
              Text(
                "Hello  ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1),
              ),
              Text(
                '$nama',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: CircleAvatar(
                  backgroundImage: AssetImage('asset/images.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Profil.router);
                },
                icon: Icon(
                  Icons.miscellaneous_services_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              height: MediaQuery.of(context).size.height / 1.2,
              child: PageStorage(
                child: tampilScreen,
                bucket: bucket,
              ),
            ),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Color(0xffa7bb9f),
          textColor: Color(0xffa7bb9f),
          inactiveIconColor: Color(0xffa7bb9f),
          activeIconColor: Colors.white,
          tabs: [
            TabData(iconData: Icons.upload_outlined, title: "Get Data"),
            TabData(iconData: Icons.download_outlined, title: "Crud Data"),
            TabData(iconData: Icons.shopping_basket, title: "Keranjang"),
          ],
          initialSelection: 0,
          key: bottomkey,
          onTabChangedListener: (i) {
            setState(() {
              _page = i;
              tampilScreen = screens[i];
            });
          },
        ),
      ),
    );
  }
}
