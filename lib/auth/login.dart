import 'dart:convert';
import 'package:final_task/api.dart';
import 'package:final_task/auth/register.dart';
import 'package:final_task/page/splash.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({
    Key key,
  }) : super(key: key);
  static const router = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Client http = Client();
  bool pengecekan = true;
  final formKey = GlobalKey();
  final _username = TextEditingController();
  final _password = TextEditingController();
  String msg = '';

  tampilPassword() {
    setState(() {
      pengecekan = !pengecekan;
    });
  }

  Future<List> _login() async {
    final response = await http.post(Api.url + '/login.php', body: {
      "username": _username.text,
      "password": _password.text,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    String nama = data['nama'];
    String iduser = data['id'];
    if (value == 1) {
      savePref(value, nama, iduser);
      showToast('Selamat datang $nama.');
      Navigator.pushReplacementNamed(context, Splash.router);
    } else {
      _username.clear();
      _password.clear();
      showToast('Invalid Data');
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  void savePref(int value, String nama, String iduser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", value);
    preferences.setString("nama", nama);
    preferences.setString("id", iduser);
    preferences.commit();
    setState(() {});
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getInt("value") == 1) {
        Navigator.pushReplacementNamed(context, Splash.router);
      }
    });
  }

  showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Color(0xffa7bb9f),
        textColor: Colors.white);
  }

  Widget formlogin() {
    return Container(
      margin: EdgeInsets.only(top: 120, left: 40),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 30,
                color: const Color(0xff707070),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: TextFormField(
              controller: _username,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.person_rounded),
                  hintText: "Username"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: TextFormField(
              controller: _password,
              obscureText: pengecekan,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: tampilPassword,
                    icon: Icon(
                        pengecekan ? Icons.visibility_off : Icons.visibility),
                  ),
                  hintText: "Password"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              if (_username.text == '') {
                showToast('Pastkan Username Telah Diisi.');
              } else if (_password.text == '') {
                showToast('Pastikan Password Telah Diisi.');
              } else {
                _login();
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width / 1.5,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xffa7bb9f),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color(0xfff9f9f9),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Row(
              children: [
                Text(
                  'Belum Punya Akun?',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xff707070),
                  ),
                  textAlign: TextAlign.left,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Register.router);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      'klik disini.',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xffa7bb9f),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: formKey,
        backgroundColor: const Color(0xfffafafa),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0.0, 529.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('asset/bottomimg.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                formlogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
