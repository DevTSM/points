import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> getLineGPSDoc() {
  return FirebaseFirestore.instance.collection("/Points_GPS_2").get();
}

getPasillosP() {
  return FirebaseFirestore.instance.collection("/PasillosGPS").get();
}

update(String id, List<Map<String, dynamic>> conection) {
  return FirebaseFirestore.instance
      .collection("/PasillosGPS")
      .doc(id)
      .set({"conexiones": conection});
}

class FirebaseDBServices {
  //Obtener Pasillos

  //Nuevo Pasillo
  static Future<void>? setNewPasillo(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("/PasillosGPS").doc().set(data);
  }
}
