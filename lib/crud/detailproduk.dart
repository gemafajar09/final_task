import 'dart:convert';

import 'package:final_task/api.dart';
import 'package:final_task/model/crudkategori.dart';
import 'package:final_task/model/getproduk.dart';
import 'package:final_task/page/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detailproduk extends StatefulWidget {
  static const router = '/detailproduk';
  @override
  _DetailprodukState createState() => _DetailprodukState();
}

class _DetailprodukState extends State<Detailproduk> {
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

  Future<List<Getproduk>> getproduk(kategoris) async {
    List<Getproduk> listproduk = [];
    final res =
        await http.get(Api.url + '/crud/getproduct.php?kategori=' + kategoris);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      for (int i = 0; i < data.length; i++) {
        var produk = Getproduk(
            idProduk: data[i]["id_produk"],
            nama: data[i]["nama"],
            foto: data[i]["foto"],
            jumlah: data[i]["jumlah"],
            kategori: data[i]["kategori"],
            harga: data[i]["harga"]);
        listproduk.add(produk);
      }
      return listproduk;
    } else {
      return [];
    }
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

  Widget header() {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: Colors.grey,
        image: DecorationImage(
          image: AssetImage('asset/userbg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Text(
          "Detail Produk",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget kategori() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1,
      child: FutureBuilder<List<Crudkategori>>(
        future: api.getcrudkategori(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var kategori = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: kategori.length != null ? kategori.length : 0,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    getproduk(kategori[i].kate);
                    setState(() {
                      kategoris = kategori[i].kate;
                    });
                  },
                  child: Container(
                    height: 20,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        kategori[i].kate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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

  Widget product() {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 1,
      height: MediaQuery.of(context).size.height / 1,
      child: FutureBuilder<List<Getproduk>>(
        future: getproduk(kategoris),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var produk = snapshot.data;
            if (produk.length == 0) {
              return Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: Image(
                    image: AssetImage('asset/nodata.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            } else {
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
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30)),
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
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      header(),
                      kategori(),
                      product(),
                    ],
                  ),
                  BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Home.router);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
