class Getkeranjang {
  String idKeranjang;
  String idProduk;
  String nama;
  String foto;
  String jumlah;
  String kategori;
  String harga;
  String tanggal;
  String total;

  Getkeranjang(
      {this.idKeranjang,
      this.idProduk,
      this.nama,
      this.foto,
      this.jumlah,
      this.kategori,
      this.harga,
      this.tanggal,
      this.total});

  Getkeranjang.fromJson(Map<String, dynamic> json) {
    idKeranjang = json['id_keranjang'];
    idProduk = json['id_produk'];
    nama = json['nama'];
    foto = json['foto'];
    jumlah = json['jumlah'];
    kategori = json['kategori'];
    harga = json['harga'];
    tanggal = json['tanggal'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_keranjang'] = this.idKeranjang;
    data['id_produk'] = this.idProduk;
    data['nama'] = this.nama;
    data['foto'] = this.foto;
    data['jumlah'] = this.jumlah;
    data['kategori'] = this.kategori;
    data['harga'] = this.harga;
    data['tanggal'] = this.tanggal;
    data['total'] = this.total;
    return data;
  }
}
