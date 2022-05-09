import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
Future<String> deleteFireBaseStorageItem(String fileUrl) async {

String filePath = fileUrl
                  .replaceAll(new 
                  RegExp(r'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/'), '');

filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

var storageReferance = FirebaseStorage.instance.ref();
bool succesfful=false;
await storageReferance.child(filePath).delete().then((_) => succesfful=true );
return succesfful?"Successfully deletedstorage item":"Error";
}
Future<String> updateShop(String id, List<String> multimedia) async {
  try{
    bool isThen=false;
  await FirebaseFirestore.instance
      .collection("/Locales")
      .doc(id)
      .update({"multimedia": multimedia}).then((value) => isThen=true);
      if(isThen){
        return "Exito";
      }else{
        return "";
      }
  }catch(e){
    return "";
  }
}
Future<String> updateDisableShop(String id, bool isDisable) async {
  try{
    bool isThen=false;
  await FirebaseFirestore.instance
      .collection("/Locales")
      .doc(id)
      .update({"activo": isDisable}).then((value) => isThen=true);
      if(isThen){
        return "Exito";
      }else{
        return "";
      }
  }catch(e){
    return "";
  }
}


class FirebaseDBServices {
  //Obtener Pasillos

  //Nuevo Pasillo
  static Future<void>? setNewPasillo(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("/PasillosGPS").doc().set(data);
  }
}
