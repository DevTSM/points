import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:points/models/conection.dart';

class Node {
  String id;
  int index;
  double lat;
  double lng;
  List<Connection> conections;
  Node(
      {required this.id,
      required this.index,
      required this.lat,
      required this.lng,
      required this.conections});
  factory Node.fromState() {
    return Node(id: "0", index: 0, lat: 0, lng: 0, conections: []);
  }
  factory Node.fromData(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Node(
        id: doc.id,
        index: data["v"],
        lat: data["lat"],
        lng: data["lng"],
        conections: data["conexiones"] != null
            ? data["conexiones"].map((e) {
                return Connection.fromData(e);
              }).toList()
            : []);
  }
  map() {
    return {
      "id": id,
      "index": index,
      "lat": lat,
      "lng": lng,
      "conexiones": conections.map((e) => e.map()).toList()
    };
  }

  setConnection(Node nodeConnection) {
    double distanceInMeters = Geolocator.distanceBetween(
        lat, lng, nodeConnection.lat, nodeConnection.lng);
    conections
        .add(Connection(id: nodeConnection.id, distance: distanceInMeters));
  }
}
