class Connection {
  String id;
  double distance;
  Connection({required this.id, required this.distance});
  factory Connection.fromData(Map<String, dynamic> data) {
    return Connection(id: data["id"], distance: data["distancia"]);
  }
  map() {
    return {"id": id, "distancia": distance};
  }
}
