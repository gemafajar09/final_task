import 'dart:convert';

import 'package:final_task/api.dart';
import 'package:final_task/page/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:final_task/model/crudkategori.dart';

class Kategoriadd extends StatefulWidget {
  static const router = '/crud/addkategori';
  @override
  _KategoriaddState createState() => _KategoriaddState();
}

class _KategoriaddState extends State<Kategoriadd> {
  final _kategori = TextEditingController();
  Api api = Api();
  var id = '';
  var msg = '';
  Future<List> adddata() async {
    final res = await http.post(Api.url + '/addkategori.php',
        body: {'id': id, 'kategori': _kategori.text});
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      _kategori.clear();
      setState(() {
        id = '';
      });
      showToast(data['pesan']);
    }
  }

  Future<List> deletedata(ids) async {
    final res = await http.get(Api.url + '/hapuskategori.php?id=' + ids);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        id = '';
      });
      showToast(data['pesan']);
    }
  }

  Widget listkategori() {
    return FutureBuilder<List<Crudkategori>>(
      future: api.getcrudkategori(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var crudkt = snapshot.data;
          return ListView.builder(
            itemCount: crudkt.length != '' ? crudkt.length : 0,
            itemBuilder: (context, i) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 50,
                      child: Text(
                        crudkt[i].kate,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 50,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                var kategori = crudkt[i].kate.toString();
                                id = crudkt[i].idKate.toString();
                                _kategori.text = kategori;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.green),
                            onPressed: () {
                              deletedata(crudkt[i].idKate);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
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
        body: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height / 1,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('asset/userbg.png'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Color(0xffa7bb9f),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 20,
                                child: Center(
                                  child: Text(
                                    'Kategori',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _kategori,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      suffixIcon: Icon(Icons.category),
                                      hintText: "Kategori"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: MaterialButton(
                                  height: 50,
                                  minWidth: 50,
                                  elevation: 5,
                                  color: Color(0xffa7bb9f),
                                  onPressed: () {
                                    adddata();
                                  },
                                  child: Center(
                                    child: Text('Save'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: listkategori(),
                        )
                      ],
                    ),
                  ),
                  BackButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Home.router);
                      })
                ],
              )),
        ),
      ),
    );
  }
}
