import 'dart:convert';

import 'package:final_task/api.dart';
import 'package:final_task/crud/editproduk.dart';
import 'package:final_task/model/crudkategori.dart';
import 'package:final_task/page/home.dart';
import 'package:flutter/material.dart';
import 'package:final_task/model/getproduk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Listproduk extends StatefulWidget {
  static const router = '/listproduk';
  @override
  _ListprodukState createState() => _ListprodukState();
}

class _ListprodukState extends State<Listproduk> {
  Api api = Api();
  var kategoris = 'All';

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

  hapus(id) async {
    final res = await http.get(Api.url + '/crud/deleteproduk.php?id=' + id);
    if (res.statusCode == 200) {
      var msg = jsonDecode(res.body);
      showToast(msg['pesan']);
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
          "List Produk",
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

  Widget content() {
    return Container(
      height: MediaQuery.of(context).size.height / 1,
      padding: EdgeInsets.all(10),
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
              return ListView.builder(
                itemCount: produk.length,
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                            ),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(produk[i].foto),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width / 1.8,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    produk[i].nama,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Stok : " + produk[i].jumlah,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Kategori : " + produk[i].kategori,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Harga : " + "Rp." + produk[i].harga,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Editproduk(
                                                    model: produk[i],
                                                  )));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      hapus(produk[i].idProduk);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        )
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
                    content(),
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
      ),
    );
  }
}
