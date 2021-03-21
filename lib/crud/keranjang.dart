import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:final_task/model/getkeranjang.dart';
import 'package:final_task/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Keranjang extends StatefulWidget {
  static const router = '/keranjang';
  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  String iduser;
  final jumlahs = TextEditingController();
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

  Future<List<Getkeranjang>> _keranjang() async {
    List<Getkeranjang> listkeranjang = [];
    final res =
        await http.get(Api.url + '/crud/getkeranjang.php?id_user=' + iduser);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      for (int i = 0; i < data.length; i++) {
        var listkrj = Getkeranjang(
          idKeranjang: data[i]['id_keranjang'],
          idProduk: data[i]['id_produk'],
          nama: data[i]['nama'],
          foto: data[i]["foto"],
          jumlah: data[i]["jumlah"],
          kategori: data[i]["kategori"],
          harga: data[i]["harga"],
          tanggal: data[i]["tanggal"],
          total: data[i]["total"].toString(),
        );
        listkeranjang.add(listkrj);
      }
      return listkeranjang;
    } else {
      return [];
    }
  }

  void sum(id) async {
    final res = await http.post(Api.url + '/crud/addkeranjang.php',
        body: {'id_keranjang': id, 'action': 'sum'});
    if (res.statusCode == 200) {
      setState(() {});
    }
  }

  void min(id) async {
    final res = await http.post(Api.url + '/crud/addkeranjang.php',
        body: {'id_keranjang': id, 'action': 'min'});
    if (res.statusCode == 200) {
      setState(() {});
    }
  }

  hapus(id) async {
    final res = await http.get(Api.url + '/crud/hapuskeranjang.php?id=' + id);
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

  void checkout() async {
    final res =
        await http.post(Api.url + "/crud/checkout.php", body: {'id': iduser});
    if (res.statusCode == 200) {
      print(res.body);
      setState(() {});
    }
  }

  Widget content() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      padding: EdgeInsets.all(10),
      child: FutureBuilder<List<Getkeranjang>>(
        future: _keranjang(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var keranjang = snapshot.data;

            if (keranjang.length == 0) {
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
                itemCount: keranjang.length,
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
                              image: NetworkImage(keranjang[i].foto),
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
                                    keranjang[i].nama,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Harga : " + "Rp." + keranjang[i].harga,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Kategori : " + keranjang[i].kategori,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Total : " + "Rp." + keranjang[i].total,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.navigate_before_outlined,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          min(keranjang[i].idKeranjang);
                                        },
                                      ),
                                      Container(
                                        width: 50,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                            child: Text(keranjang[i].jumlah,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ))),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.navigate_next_outlined,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          sum(keranjang[i].idKeranjang);
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      hapus(keranjang[i].idKeranjang);
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              content(),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 50,
                width: MediaQuery.of(context).size.width / 1,
                child: RaisedButton(
                  onPressed: () {
                    checkout();
                  },
                  child: Center(
                    child: Text('Checkout'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
