import 'package:final_task/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  static const router = '/profil';
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String nama = '';

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

  void logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setInt("id", null);
      preferences.setInt("nama", null);
      preferences.commit();
      Navigator.pushReplacementNamed(context, Login.router);
    });
  }

  Widget image() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        gradient: LinearGradient(
          begin: Alignment(0.71, -0.3),
          end: Alignment(-0.49, 1.11),
          colors: [const Color(0xe32ebedc), const Color(0xff53e5c2)],
          stops: [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('asset/images.png'),
              maxRadius: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text('$nama',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xfffafafa),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                image(),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 180),
                    width: 351.0,
                    height: 81.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: MaterialButton(
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xe32ebedc),
                          ),
                        ),
                        onPressed: () {
                          logOut();
                        },
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0.0, 528.0),
                  child: Container(
                    width: 414.0,
                    height: 207.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('asset/bottomimg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
