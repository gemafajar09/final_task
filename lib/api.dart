import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:final_task/model/slider.dart';
import 'package:final_task/model/kategori.dart';
import 'package:final_task/model/buku.dart';
import 'package:final_task/model/crudkategori.dart';
import 'package:final_task/model/getproduk.dart';

class Api {
  static String url = 'http://192.168.1.5/final';

  Future<List<Sliders>> getSlider() async {
    List<Sliders> listSlider = [];
    final respon = await http.get('$url/slider.php');
    if (respon.statusCode == 200) {
      var data = jsonDecode(respon.body);
      for (int i = 0; i < data.length; i++) {
        var slider =
            Sliders(idSlider: data[i]["id_slider"], gambar: data[i]["gambar"]);
        listSlider.add(slider);
      }
      return listSlider;
    } else {
      return [];
    }
  }

  Future<List<Kategori>> getKategori() async {
    List<Kategori> listKategori = [];
    final respon = await http.get('$url/get/kategori.php');
    if (respon.statusCode == 200) {
      var data = jsonDecode(respon.body);
      for (int i = 0; i < data.length; i++) {
        var kategoris = Kategori(
            idKategori: data[i]["id_kategori"], kategori: data[i]["kategori"]);
        listKategori.add(kategoris);
      }
      return listKategori;
    } else {
      return [];
    }
  }

  Future<List<Buku>> getBuku() async {
    List<Buku> listBuku = [];
    final respon = await http.get('$url/get/buku.php?id=0');
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

  // crud
  Future<List<Crudkategori>> getcrudkategori() async {
    List<Crudkategori> listcrudkategori = [];
    final res = await http.get('$url/crud/showkategori.php');
    if (res.statusCode == 200) {
      var cdata = jsonDecode(res.body);
      for (int i = 0; i < cdata.length; i++) {
        var crudkategori =
            Crudkategori(idKate: cdata[i]['id_kate'], kate: cdata[i]['kate']);
        listcrudkategori.add(crudkategori);
      }
      return listcrudkategori;
    } else {
      return [];
    }
  }

  Future<List<Getproduk>> getproduk() async {
    List<Getproduk> listproduk = [];
    final res = await http.get('$url/crud/getproduct.php?kategori=All');
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
}
