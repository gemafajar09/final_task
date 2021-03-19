class Crudkategori {
  String idKate;
  String kate;

  Crudkategori({this.idKate, this.kate});

  Crudkategori.fromJson(Map<String, dynamic> json) {
    idKate = json['id_kate'];
    kate = json['kate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_kate'] = this.idKate;
    data['kate'] = this.kate;
    return data;
  }
}
