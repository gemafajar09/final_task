import 'dart:convert';

import 'package:final_task/api.dart';
import 'package:final_task/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  Register({
    Key key,
  }) : super(key: key);
  static const router = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool pengecekan = true;
  final formKey = GlobalKey();
  final _nama = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  var msg = '';

  tampilPassword() {
    setState(() {
      pengecekan = !pengecekan;
    });
  }

  Future<List> register() async {
    final response = await http.post(Api.url + '/register.php', body: {
      "nama": _nama.text,
      "username": _username.text,
      "password": _password.text,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    if (value == 1) {
      showToast('Silahkan login.');
      Navigator.pushReplacementNamed(context, Login.router);
    } else {
      _nama.clear();
      _username.clear();
      _password.clear();
      showToast('Invalid Data');
    }
  }

  showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green[200],
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
              'REGISTER',
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
              controller: _nama,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.person_rounded),
                  hintText: "Nama"),
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
              if (_username.text.isNotEmpty && _nama.text.isNotEmpty) {
                if (_password.text.isNotEmpty) {
                  register();
                } else {
                  showToast('Maaf Password Kosong.!');
                }
              } else {
                showToast('Maaf Periksa Kembali.!');
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
                'Daftar',
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
                  'Sudah Punya Akun?',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xff707070),
                  ),
                  textAlign: TextAlign.left,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Login.router);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      'Log In.',
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
    return new WillPopScope(
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
                BackButton(
                  color: Color(0xffa7bb9f),
                  onPressed: () {
                    Navigator.pushNamed(context, Login.router);
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
