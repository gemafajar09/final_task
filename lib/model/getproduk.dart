class Getproduk {
  String idProduk;
  String nama;
  String foto;
  String jumlah;
  String kategori;
  String harga;

  Getproduk(
      {this.idProduk,
      this.nama,
      this.foto,
      this.jumlah,
      this.kategori,
      this.harga});

  Getproduk.fromJson(Map<String, dynamic> json) {
    idProduk = json['id_produk'];
    nama = json['nama'];
    foto = json['foto'];
    jumlah = json['jumlah'];
    kategori = json['kategori'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_produk'] = this.idProduk;
    data['nama'] = this.nama;
    data['foto'] = this.foto;
    data['jumlah'] = this.jumlah;
    data['kategori'] = this.kategori;
    data['harga'] = this.harga;
    return data;
  }
}
