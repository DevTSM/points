import 'package:cloud_firestore/cloud_firestore.dart';

getPasillos() {
  return FirebaseFirestore.instance.collection("/PasillosGPS").get();
}

class FirebaseDBServices {
  //Obtener Pasillos

  //Nuevo Pasillo
  static Future<void>? setNewPasillo(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("/PasillosGPS").doc().set(data);
  }
}
