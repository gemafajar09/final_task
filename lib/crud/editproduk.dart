import 'dart:convert';
import 'dart:io';

import 'package:final_task/api.dart';
import 'package:final_task/crud/listproduk.dart';
import 'package:final_task/model/getproduk.dart';
import 'package:final_task/page/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Editproduk extends StatefulWidget {
  static const router = '/editproduk';
  Editproduk({Key key, this.model});
  Getproduk model;
  @override
  _EditprodukState createState() => _EditprodukState();
}

class _EditprodukState extends State<Editproduk> {
  Api api = Api();
  Getproduk model;
  File image;
  final formKey = GlobalKey<FormState>();
  List kategori = [];
  String pilihkategori, baseimage, filename, id;
  final namaproduk = TextEditingController();
  final jumlahproduk = TextEditingController();
  final hargaproduk = TextEditingController();

  @override
  void initState() {
    model = widget.model;
    namaproduk.text = model.nama;
    jumlahproduk.text = model.jumlah;
    hargaproduk.text = model.harga;
    pilihkategori = model.kategori;
    id = model.idProduk;
    kategories();
    super.initState();
  }

  void savefile() async {
    if (image != null) {
      List<int> images = image.readAsBytesSync();
      baseimage = base64Encode(images);
      filename = image.path.split('/').last;
    } else {
      baseimage = '';
      filename = '';
    }
    final res = await http.post(Api.url + '/crud/addproduk.php', body: {
      "id": id,
      "image": baseimage,
      "filename": filename,
      "nama": namaproduk.text,
      "jumlah": jumlahproduk.text,
      "kategori": pilihkategori,
      "harga": hargaproduk.text
    });
    print("image: " + baseimage);
    print("nama: " + namaproduk.text);
    print("jumlah: " + jumlahproduk.text);
    print("kategori: " + pilihkategori);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      showToast(data['pesan']);
      namaproduk.clear();
      jumlahproduk.clear();
      hargaproduk.clear();
      if (image != null) {
        image.delete();
      }
      setState(() {});
      Navigator.pushReplacementNamed(context, Listproduk.router);
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

  void bukacamera() async {
    var img = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (img != null) {
      setState(() {
        image = img;
      });
    }
  }

  void bukagallery() async {
    var glr = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (glr != null) {
      setState(() {
        image = glr;
      });
    }
  }

  Widget showimage() {
    if (image != null) {
      return Flexible(
        child: Image.file(
          image,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Flexible(
        child: Image(
          image: NetworkImage(model.foto),
          fit: BoxFit.fill,
        ),
      );
    }
  }

  void kategories() async {
    final res = await http.get(Api.url + '/showkategori.php');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      setState(() {
        kategori = data;
      });
    }
  }

  alert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Ambil Gambar'),
                    onTap: () {
                      bukacamera();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Buka Gallery'),
                    onTap: () {
                      bukagallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: formKey,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 1,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.green[100],
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Edit Produk",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: namaproduk,
                            decoration: InputDecoration(
                              hintText: 'Nama Product',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: jumlahproduk,
                            decoration: InputDecoration(
                              hintText: 'Jumlah',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: hargaproduk,
                            decoration: InputDecoration(
                              hintText: 'Harga',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20),
                                ),
                              ),
                            ),
                            hint: Text('-Kategori-'),
                            value: pilihkategori,
                            onChanged: (value) {
                              setState(() {
                                pilihkategori = value;
                              });
                            },
                            items: kategori.map((item) {
                                  return DropdownMenuItem(
                                    child: new Text(item['kate']),
                                    value: item['kate'],
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                        SizedBox(height: 10),
                        showimage(),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            alert();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              "Ambil Gambar",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(),
                          child: MaterialButton(
                            minWidth: 120,
                            height: 50,
                            color: Color(0xffa7bb9f),
                            elevation: 5,
                            onPressed: () {
                              savefile();
                            },
                            child: Text('Save',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      ],
                    ))
              ],
            ),
            BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, Home.router);
              },
            )
          ],
        ))),
      ),
    );
  }
}
