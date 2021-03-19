import 'dart:convert';

import 'package:final_task/detail/bukudeskripsi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_task/model/buku.dart';
import 'package:final_task/api.dart';

class Bukukategori extends StatefulWidget {
  Bukukategori({Key key, this.idbuku, this.kategori}) : super(key: key);
  var idbuku;
  var kategori;
  @override
  _BukukategoriState createState() => _BukukategoriState();
}

class _BukukategoriState extends State<Bukukategori> {
  Api api = Api();
  var id;
  var judul;
  @override
  void initState() {
    id = widget.idbuku;
    judul = widget.kategori;
    super.initState();
  }

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

  Widget header() {
    return Container(
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'List Buku',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$judul',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
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
                          color: Colors.amber,
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
                    header(),
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
