class BarangModel {
  String? idBarang;
  String? title;
  String? description;
  String? price;
  String? image;
  String? idUser;
  String? nama;

  BarangModel(
      this.idBarang,
      this.title,
      this.description,
      this.price,
      this.image,
      this.idUser,
      this.nama);

  BarangModel.fromJson(Map<String, dynamic> json) {
    idBarang = json['id_barang'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    idUser = json['id_user'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_barang'] = this.idBarang;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['id_user'] = this.idUser;
    data['nama'] = this.nama;
    return data;
  }
}
