import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:points/models/category.dart';
import 'package:points/services/firebase_db_service.dart';

class ShopsModel {
  DateTime expiration;
  List<CategoryModel> category;
  List<String> multimedia;
  String id;
  String name;
  String token;
  String tokenA;
  bool isAvailable;
  bool isPrime;
  ShopsModel(
      {required this.id,
      required this.expiration,
      required this.category,
      required this.multimedia,
      required this.name,
      required this.token,
      required this.tokenA,
      required this.isAvailable,
      required this.isPrime});
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
    DateTime created=data["fechaAsignacion"].toDate();
    return ShopsModel(
      expiration: DateTime(created.year+1,created.month,created.day),
        category: categorias,
        multimedia: data["multimedia"] != null
            ? List.from(data["multimedia"])
            : [
                "https://png.pngtree.com/element_our/png_detail/20181124/shop-vector-icon-png_246574.jpg"
              ],
              id:doc.id,
        name: data["nombreLocal"],
        token: data["token"],
        tokenA: data["tokenA"],
        isAvailable: data["activo"],
        isPrime: data["tokenA"]=="00-2");
  }
  deleteImage(String url) async {
    multimedia.remove(url);
    await updateShop(id, multimedia).then((value)async  => print(await deleteFireBaseStorageItem(url)));
  }
  bool updateDisable(){
    isAvailable=!isAvailable;
    return isAvailable;
  }
}
