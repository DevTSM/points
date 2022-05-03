import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:points/models/category.dart';

class ShopsModel {
  List<CategoryModel> category;
  List<String> multimedia;
  String name;
  String token;
  String tokenA;
  bool isAvailable;
  ShopsModel(
      {required this.category,
      required this.multimedia,
      required this.name,
      required this.token,
      required this.tokenA,
      required this.isAvailable});
  factory ShopsModel.fromFirebase(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> calificaciones = [];
    List<CategoryModel> categorias = [];
    if (data["calificaciones"] != null) {
      data["calificaciones"].forEach((element) => calificaciones.add(element));
    }
    if (data["categoria"] != null) {
      data["categoria"].forEach(
          (element) => categorias.add(CategoryModel.fromData(element)));
    }
    return ShopsModel(
        category: categorias,
        multimedia: data["multimedia"] != null
            ? List.from(data["multimedia"])
            : [
                "https://png.pngtree.com/element_our/png_detail/20181124/shop-vector-icon-png_246574.jpg"
              ],
        name: data["nombreLocal"],
        token: data["token"],
        tokenA: data["tokenA"],
        isAvailable: data["activo"]);
  }
}
