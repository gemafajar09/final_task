class Buku {
  String idBuku;
  String kategori;
  String foto;
  String judul;
  String deskripsi;
  String penerbit;

  Buku({this.idBuku, this.kategori, this.foto, this.judul, this.deskripsi, this.penerbit});

  Buku.fromJson(Map<String, dynamic> json) {
    idBuku = json['id_buku'];
    kategori = json['kategori'];
    foto = json['foto'];
    judul = json['judul'];
    deskripsi = json['deskripsi'];
    penerbit = json['penerbit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_buku'] = this.idBuku;
    data['kategori'] = this.kategori;
    data['foto'] = this.foto;
    data['judul'] = this.judul;
    data['deskripsi'] = this.deskripsi;
    data['penerbit'] = this.penerbit;
    return data;
  }
}