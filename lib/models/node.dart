import 'dart:developer';

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
  factory Node.fromData(Map<String, dynamic> data, int index) {
    return Node(
        id: data["id"],
        index: data["index"] /*index == 0 ? 0 : index - 1*/,
        lat: data["lat"],
        lng: data["lng"],
        conections: data["conexiones"] != null
            ? List.from(
                data["conexiones"].map((e) => Connection.fromData(e)).toList())
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

  deleteConnection(Node nodeConnection) {
    conections.removeWhere((element) => element.id == nodeConnection.id);
  }
}
