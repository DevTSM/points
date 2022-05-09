import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oktoast/oktoast.dart';
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
  late String idDoc;
  late List<Node> nodes;
  late Node node1, node2;
  late double lat, lng;
  late bool isPin;

  @override
  void initState() {
    super.initState();
    nodes = [];
    idDoc = "";
    lat = 0;
    lng = 0;
    isPin = false;
    setCurrentLocation();
    _currentLocation = Position(
        latitude: 19.2774861,
        longitude: -98.430105555556,
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
    getLineGPS();
    getNodes();
    //configLoading();
  }

  // void configLoading() {
  //   EasyLoading.instance
  //     ..displayDuration = const Duration(milliseconds: 2000)
  //     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
  //     ..loadingStyle = EasyLoadingStyle.dark
  //     ..indicatorSize = 45.0
  //     ..radius = 10.0
  //     ..progressColor = Colors.yellow
  //     ..backgroundColor = Colors.green
  //     ..indicatorColor = Colors.yellow
  //     ..textColor = Colors.yellow
  //     ..maskColor = Colors.blue.withOpacity(0.5)
  //     ..userInteractions = true
  //     ..dismissOnTap = false
  //     ..customAnimation = CustomAnimation();
  // }

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
    await getNodesDoc().then((value) async {
      idDoc = value.docs.first.id;
      nodes = [];
      for (var e in value.docs.first["nodos"]) {
        Node valueNode = Node.fromData(e, nodes.length);
        if (nodes
            .where((element) =>
                element.lat == valueNode.lat && element.lng == valueNode.lng)
            .toList()
            .isEmpty) nodes.add(valueNode);
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
      getTraced();
    });
  }

  getTraced() {
    log("obteniendo trazado");
    int count = 1;
    nodes.map((e) {
      List<LatLng> points = <LatLng>[];
      e.conections.map((e1) {
        Node nodeConecction =
            nodes.where((element) => element.id == e1.id).toList().first;
        points.add(LatLng(nodeConecction.lat, nodeConecction.lng));
        points.add(LatLng(e.lat, e.lng));
      }).toList();
      final String polygonIdV = 'polygon_id_$count';
      count++;
      setState(() {
        polylines2.add(Polyline(
          polylineId: PolylineId(polygonIdV),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
        points = [];
      });
    }).toList();
  }

  getPin() {
    return BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: .5, size: Size(8, 8)),
        'assets/point.jpg');
  }

  Widget pin() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(bottom: 45, left: 2),
        child: const Icon(
          Icons.location_on_outlined,
          color: Colors.red,
          size: 45,
          //color: CupertinoColors.destructiveRed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onMapCreated(GoogleMapController controller) {
    controllerMap = controller;
    //setCurrentLocation();
  }

  void loading() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          ));
        });
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
                        if (!isConnection) {
                          setState(() {
                            node1 = Node.fromState();
                            node2 = Node.fromState();
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: Text(isConnection ? 'No' : 'Aceptar'))),
              !isConnection
                  ? Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () {
                          node1.deleteConnection(node2);
                          node2.deleteConnection(node1);
                          setState(() {
                            node1 = Node.fromState();
                            node2 = Node.fromState();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Eliminar'),
                      ))
                  : Container(),
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
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width,
          color: Colors.orange,
          child: mapa(),
        ),
        isPin ? pin() : Container(),
        Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Text("Nodo 1: ${node1.index}")),
            Container(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Text("Nodo 2: ${node2.index}"),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isPin = !isPin;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      color: Colors.green,
                      child: const Text("Pin")),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: isPin
                      ? () async {
                          log("agregando punto");
                          int idR = nodes.length;
                          setState(() {
                            nodes.add(Node(
                                id: "${nodes.length}",
                                index: nodes.length,
                                lat: lat,
                                lng: lng,
                                conections: []));
                            _lista.add(Marker(
                                onTap: () {
                                  setState(() {
                                    if (node1.id != "0") {
                                      node2 = nodes[idR];
                                      bool flag1 = (node2.conections
                                              .where((e) => e.id == node1.id)
                                              .toList())
                                          .isEmpty;
                                      bool flag2 = (node1.conections
                                              .where((e) => e.id == node2.id)
                                              .toList())
                                          .isEmpty;
                                      _showConnection(flag1 && flag2);
                                    } else {
                                      node1 = nodes[idR];
                                    }
                                  });
                                },
                                markerId: MarkerId(idR.toString()),
                                position:
                                    LatLng(nodes[idR].lat, nodes[idR].lng),
                                infoWindow: InfoWindow(
                                  title: nodes[idR].index.toString(),
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueViolet)));
                          });
                        }
                      : () {},
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      color: Colors.green,
                      child: const Text("Agregar punto")),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    log("guardamos cambios");
                    nodes.sort(((a, b) {
                      List<int> tem = [a.index, b.index];
                      tem.sort();
                      if (tem.first == a.index) {
                        return -1;
                      }
                      if (tem.first == b.index) {
                        return 1;
                      }
                      return 0;
                    }));
                    loading();
                    try {
                      await update(idDoc, nodes).then((value) {
                        Navigator.pop(context);
                        getNodes();
                      });
                    } catch (e) {
                      Navigator.pop(context);
                      showToast(
                        "Ocurrio un error",
                        position: ToastPosition.bottom,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        radius: 13.0,
                        textStyle: const TextStyle(
                            fontSize: 18.0, color: Colors.white),
                        animationBuilder: const Miui10AnimBuilder(),
                      );
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      color: Colors.amber,
                      child: const Text("Guardar Cambios")),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                    child: TextButton(
                  child: const Text("Limpiar"),
                  onPressed: () {
                    setState(() {
                      node1 = Node.fromState();
                      node2 = Node.fromState();
                    });
                  },
                )),
              ],
            ),
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
      markers: widget.index != 2
          ? {
              for (int i = 0; i < _lista.length; i++) _lista[i],
            }
          : <Marker>{},
      polylines: widget.index == 0
          ? polylines
          : widget.index == 2
              ? polylines2
              : HashSet<Polyline>(),
      onMapCreated: _onMapCreated,
      onCameraMove: (CameraPosition camerapos) {
        lat = camerapos.target.latitude;
        lng = camerapos.target.longitude;
      },
      onCameraIdle: () async {
        setState(() {});
        // name.text = await addressBloc.onLookupAddressPressed(
        //     addressBloc.lat, addressBloc.lng);
        //POSICION DEL CENTRO AL DETENERSE el MOVIMIENTO
        log("=========latitud centro final $lat");
        log("=========logitud centro final= $lng");
      },
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
