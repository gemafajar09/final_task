import 'dart:convert';

import 'package:final_task/detail/bukudeskripsi.dart';
import 'package:http/http.dart' as http;
import 'package:final_task/api.dart';
import 'package:final_task/model/kategori.dart';
import 'package:final_task/model/buku.dart';
import 'package:flutter/material.dart';

class Detailbuku extends StatefulWidget {
  Detailbuku({Key key}) : super(key: key);
  static const router = '/detailBuku';
  @override
  _DetailbukuState createState() => _DetailbukuState();
}

class _DetailbukuState extends State<Detailbuku> {
  Api api = Api();
  var id = 0;
  var kategoris = 'All';

  Future<List<Buku>> bukuKategori(id) async {
    List<Buku> listBuku = [];
    final respon = await http.get(Api.url + '/get/buku.php?id=$id');
    if (respon.statusCode == 200) {
      var data = jsonDecode(respon.body);
      for (int i = 0; i < data.length; i++) {
        var buku = Buku(
            idBuku: data[i]["id_Buku"],
            kategori: data[i]["kategori"],
            foto: data[i]["foto"],
            judul: data[i]["judul"],
            deskripsi: data[i]["deskripsi"],
            penerbit: data[i]["penerbit"]);
        listBuku.add(buku);
      }
      return listBuku;
    } else {
      return [];
    }
  }

  Widget kategori() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1,
      child: FutureBuilder<List<Kategori>>(
        future: api.getKategori(),
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
                    bukuKategori(kategori[i].idKategori.toString());
                    setState(() {
                      id = int.parse(kategori[i].idKategori);
                      kategoris = kategori[i].kategori;
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
                        kategori[i].kategori,
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

  Widget tampilBuku() {
    return Container(
      padding: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height / 1.2,
      child: FutureBuilder<List<Buku>>(
        future: bukuKategori(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var buku = snapshot.data;
            if (buku.length == 0) {
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
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: buku.length != 0 ? buku.length : 0,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bukudeskripsi(
                                    model: buku[i],
                                  )));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(buku[i].foto),
                            fit: BoxFit.fill,
                          )),
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
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('asset/userbg.png'),
                            fit: BoxFit.cover,
                          )),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'List Buku',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$kategoris',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    kategori(),
                    SizedBox(
                      height: 10,
                    ),
                    tampilBuku(),
                  ],
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
    );
  }
}
