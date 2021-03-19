import 'package:final_task/api.dart';
import 'package:final_task/detail/bukudeskripsi.dart';
import 'package:final_task/detail/bukudetail.dart';
import 'package:final_task/detail/bukukategori.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:final_task/model/slider.dart';
import 'package:final_task/model/kategori.dart';
import 'package:final_task/model/buku.dart';

class Get extends StatefulWidget {
  @override
  _GetState createState() => _GetState();
}

class _GetState extends State<Get> {
  Api api = Api();

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Bukukategori(
                            idbuku: kategori[i].idKategori.toString(),
                            kategori: kategori[i].kategori,
                          ),
                        ));
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

  Widget buku() {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 1,
      height: MediaQuery.of(context).size.height / 2,
      child: FutureBuilder<List<Buku>>(
        future: api.getBuku(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var buku = snapshot.data;
            return ListView.builder(
              itemCount: buku.length != null ? buku.length : 0,
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
                  child: Card(
                    elevation: 3,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.4,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(buku[i].foto),
                            fit: BoxFit.fill,
                          )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                child: Text(
                                  buku[i].judul,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                height: 110,
                                child: Text(
                                  buku[i].deskripsi,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
            kategori(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "List Buku",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Detailbuku.router);
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
            buku()
          ],
        ),
      ),
    );
  }
}
