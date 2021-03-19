class Sliders {
  String idSlider;
  String gambar;

  Sliders({this.idSlider, this.gambar});

  Sliders.fromJson(Map<String, dynamic> json) {
    idSlider = json['id_slider'];
    gambar = json['gambar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_slider'] = this.idSlider;
    data['gambar'] = this.gambar;
    return data;
  }
}