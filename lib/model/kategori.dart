class Kategori {
  String idKategori;
  String kategori;

  Kategori({this.idKategori, this.kategori});

  Kategori.fromJson(Map<String, dynamic> json) {
    idKategori = json['id_kategori'];
    kategori = json['kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_kategori'] = this.idKategori;
    data['kategori'] = this.kategori;
    return data;
  }
}