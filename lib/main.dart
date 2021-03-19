import 'package:final_task/auth/login.dart';
import 'package:final_task/auth/register.dart';
import 'package:final_task/crud/crudproduk.dart';
import 'package:final_task/crud/detailproduk.dart';
import 'package:final_task/crud/kategoriadd.dart';
import 'package:final_task/crud/keranjang.dart';
import 'package:final_task/crud/listproduk.dart';
import 'package:final_task/detail/bukudetail.dart';
import 'package:final_task/page/home.dart';
import 'package:final_task/page/profil.dart';
import 'package:final_task/page/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final router = <String, WidgetBuilder>{
    Login.router: (_) => Login(),
    Register.router: (_) => Register(),
    Splash.router: (_) => Splash(),
    Home.router: (_) => Home(),
    Detailbuku.router: (_) => Detailbuku(),
    Profil.router: (_) => Profil(),
    Kategoriadd.router: (_) => Kategoriadd(),
    Crudproduk.router: (_) => Crudproduk(),
    Listproduk.router: (_) => Listproduk(),
    Keranjang.router: (_) => Keranjang(),
    Detailproduk.router: (_) => Detailproduk(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routes: router,
      initialRoute: Login.router,
    );
  }
}
