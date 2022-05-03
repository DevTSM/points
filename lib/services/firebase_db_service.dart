import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:points/models/node.dart';

Future<QuerySnapshot> getLineGPSDoc() {
  return FirebaseFirestore.instance.collection("/Points_GPS_2").get();
}

Future<QuerySnapshot> getNodesDoc() {
  return FirebaseFirestore.instance.collection("/Nodos").get();
}

Future<QuerySnapshot> getShops() {
  return FirebaseFirestore.instance.collection("/Locales").get();
}

Future<void> update(String id, List<Node> nodes) {
  return FirebaseFirestore.instance
      .collection("/Nodos")
      .doc(id)
      .set({"nodos": nodes.map((e) => e.map()).toList()});
}

setData(Map<String, dynamic> data) {
  return FirebaseFirestore.instance.collection("/Nodos").doc().set(data);
}

class FirebaseDBServices {
  //Obtener Pasillos

  //Nuevo Pasillo
  static Future<void>? setNewPasillo(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("/PasillosGPS").doc().set(data);
  }
}
