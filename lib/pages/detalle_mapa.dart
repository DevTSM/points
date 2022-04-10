import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:points/models/node.dart';
import 'package:points/points.dart';
import 'package:points/services/firebase_db_service.dart';

class MapaDetalle extends StatefulWidget {
  MapaDetalle({
    Key? key,
    required this.index,
  }) : super(key: key);
  int index;
  @override
  State<MapaDetalle> createState() => _MapaDetalleState();
}

class _MapaDetalleState extends State<MapaDetalle> {
  late Position _currentLocation;
  late GoogleMapController controllerMap;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  late List<Marker> _lista;
  Set<Polyline> polylines = HashSet<Polyline>();
  Set<Polyline> polylines2 = HashSet<Polyline>();
  late List<Map<String, dynamic>> nameLocal;
  late List<Map<String, dynamic>> pub;
  late String title;
  late List<Node> nodes;
  late Node node1, node2;

  @override
  void initState() {
    super.initState();
    nodes = [];
    _currentLocation = Position(
        latitude: 19.27381083,
        longitude: -98.4420637,
        accuracy: 2.0,
        altitude: 10,
        heading: 1,
        timestamp: DateTime.now(),
        speed: 1,
        speedAccuracy: 1,
        floor: 1,
        isMocked: false);
    _lista = [];
    nameLocal = [];
    node1 = Node.fromState();
    node2 = Node.fromState();
    if (widget.index == 2) {
      //getTraced();
    }
    getLineGPS();
    //getNodes();
  }

  setCurrentLocation() async {
    CameraPosition camara = CameraPosition(
      bearing: 0,
      target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
      zoom: 18.0,
    );
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      print({"permission": permission.toString()});
      _currentLocation = await Geolocator.getCurrentPosition();
      if (_currentLocation.latitude != null &&
          _currentLocation.longitude != null) {
        print("exito");
      }
      if (_currentLocation != null) {
        camara = CameraPosition(
          bearing: 0,
          target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
          zoom: 18.0,
        );
      }
    } else {
      print({"permission": permission.toString()});
    }
    controllerMap.moveCamera(CameraUpdate.newCameraPosition(camara));
  }

  Future<void> getLineGPS() async {
    await getLineGPSDoc().then((value) async {
      List<LatLng> points = <LatLng>[];
      value.docs.first["nodes"].map((e) {
        points.add(LatLng(e['lat'], e['lng']));
      }).toList();
      // Defining an ID
      PolylineId id = const PolylineId('poly');
      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.green,
        points: points,
        width: 6,
      );
      // Adding the polyline to the map
      setState(() {
        //polylines[id] = polyline;
        polylines.add(polyline);
      });
    });
  }

  Future<void> getNodes() async {
    log("ejecutando ${widget.index}");
    await getPasillosP().then((value) async {
      for (var element in value.docs) {
        setState(() {
          nodes.add(Node.fromData(element));
        });
      }
      nodes.map((element) {
        _lista.add(Marker(
            onTap: () {
              setState(() {
                if (node1.id != "0") {
                  node2 = element;
                  bool flag1 =
                      (node2.conections.where((e) => e.id == node1.id).toList())
                          .isEmpty;
                  bool flag2 =
                      (node1.conections.where((e) => e.id == node2.id).toList())
                          .isEmpty;
                  _showConnection(flag1 && flag2);
                } else {
                  node1 = element;
                }
              });
            },
            markerId: MarkerId(element.index.toString()),
            position: LatLng(element.lat, element.lng),
            infoWindow: InfoWindow(
              title: element.index.toString(),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet)));
      }).toList();
    });
  }

  getPin() {
    return BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: .5, size: Size(8, 8)),
        'assets/point.jpg');
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onMapCreated(GoogleMapController controller) {
    controllerMap = controller;
    //setCurrentLocation();
  }

  void _showConnection(bool isConnection) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(isConnection ? 'Nueva Conexion' : 'Conexion existente'),
            content: isConnection
                ? Text('¿Quieres conectar ${node1.index} con ${node2.index}?')
                : const Text("La conexion ya existe"),
            actions: <Widget>[
              Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(isConnection ? 'No' : 'Aceptar'))),
              isConnection
                  ? Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () {
                          node1.setConnection(node2);
                          node2.setConnection(node1);
                          setState(() {
                            node1 = Node.fromState();
                            node2 = Node.fromState();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Si'),
                      ))
                  : Container()
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 5,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.orange,
              child: mapa(),
            ),
            Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Text("Nodo 1: ${node1.index}")),
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Text("Nodo 1: ${node2.index}"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    child: TextButton(
                  child: Text("Limpiar"),
                  onPressed: () {
                    setState(() {
                      node1 = Node.fromState();
                      node2 = Node.fromState();
                    });
                  },
                )),
                const SizedBox(
                  height: 10,
                )
              ],
            ))
          ],
        ));
  }

  Widget finalizar() {
    return GestureDetector(
        onTap: () async {
          Position position = await Geolocator.getCurrentPosition();
          DateTime date = new DateTime.now();
          FirebaseDBServices.setNewPasillo({
            "Date": date,
            "name": "Punto con GPS",
            "lat": position.latitude,
            "lng": position.longitude,
            "index": 1
          });
          //getLocalesAll();
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * .7,
          color: Colors.orange[800],
          margin: const EdgeInsets.only(left: 22),
          child: const Center(
            child: Text(
              'Guardar Pasillo',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }

  Widget boton() {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SecondaryPage(
                title: 'Registrando Pasillo',
              ),
            ),
          );
        },
        child: Container(
          height: 50,
          width: 220,
          color: Colors.orange[800],
          child: const Center(
            child: Text(
              'Agregar Nuevo Pasillo',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }

  Widget mapa() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        zoom: 20,
      ),
      markers: {
        for (int i = 0; i < _lista.length; i++) _lista[i],
      },
      polylines: widget.index == 0 ? polylines : polylines2,
      onMapCreated: _onMapCreated,
      onCameraMove: (CameraPosition camerapos) {
        //lat1 = camerapos.target.latitude;
        //lng1 = camerapos.target.longitude;
      },
      onCameraIdle: () async {},
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
    );
  }
}
