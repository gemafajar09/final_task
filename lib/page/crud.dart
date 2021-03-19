import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:final_task/api.dart';
import 'package:final_task/crud/crudproduk.dart';
import 'package:final_task/crud/detailproduk.dart';
import 'package:final_task/crud/kategoriadd.dart';
import 'package:final_task/crud/listproduk.dart';
import 'package:final_task/model/getproduk.dart';
import 'package:final_task/model/slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Crud extends StatefulWidget {
  @override
  _CrudState createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  Api api = Api();
  var kategoris = 'All';
  String iduser;
  String idkeranjang = '';
  String jumlah = '1';

  @override
  void initState() {
    getPref();
    super.initState();
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      iduser = preferences.getString("id");
    });
  }

  Widget sliders() {
    return FutureBuilder<List<Sliders>>(
      future: api.getSlider(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var slide = snapshot.data;
          return CarouselSlider.builder(
            itemCount: slide.length,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 5,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: (context, i) {
              return Container(
                height: MediaQuery.of(context).size.height / 5.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                  image: DecorationImage(
                      image: NetworkImage(slide[i].gambar), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget cruddata() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, Kategoriadd.router);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 4,
              margin: EdgeInsets.only(left: 15, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffa7bb9f),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Add Kategori',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, Crudproduk.router);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 4,
              margin: EdgeInsets.only(left: 5, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffa7bb9f),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Add Product',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, Listproduk.router);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 4,
              margin: EdgeInsets.only(left: 5, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffa7bb9f),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'List Product',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget product() {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 1,
      height: MediaQuery.of(context).size.height / 1,
      child: FutureBuilder<List<Getproduk>>(
        future: api.getproduk(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var produk = snapshot.data;
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 3.2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: produk.length != null ? produk.length : 0,
              itemBuilder: (context, i) {
                return Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 300,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                    ),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(30)),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(produk[i].foto),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            produk[i].nama,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                          Text(
                            "Stok : " + produk[i].jumlah,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.right,
                            softWrap: true,
                          ),
                        ],
                      ),
                      Text('harga : Rp.' + produk[i].harga),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kategori : " + produk[i].kategori,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                          IconButton(
                            icon: Icon(Icons.shopping_bag_outlined),
                            color: Colors.green,
                            onPressed: () {
                              addkeranjang(produk[i].idProduk);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void addkeranjang(id) async {
    final res = await http.post(Api.url + '/crud/addkeranjang.php', body: {
      'id_keranjang': idkeranjang,
      'id_user': iduser,
      'id_produk': id,
      'jumlah': jumlah
    });
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      showToast(data['pesan']);
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.height / 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sliders(),
            SizedBox(
              height: 10,
            ),
            cruddata(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "List Product",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Detailproduk.router);
                    },
                    child: Text(
                      "Show All",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            product(),
          ],
        ),
      ),
    );
  }
}
