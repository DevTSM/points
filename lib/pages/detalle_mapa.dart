import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:points/points.dart';
import 'package:points/services/firebase_db_service.dart';

class MapaDetalle extends StatefulWidget {
  MapaDetalle({
    Key? key,
  }) : super(key: key);
  @override
  State<MapaDetalle> createState() => _MapaDetalleState();
}

class _MapaDetalleState extends State<MapaDetalle> {
  late Position _currentLocation;
  late GoogleMapController controllerMap;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  late List<Marker> _lista;
  Set<Polygon> _polygons = HashSet<Polygon>();
  late List<Map<String, dynamic>> nameLocal;
  late List<Map<String, dynamic>> pub;
  late String title;

  @override
  void initState() {
    super.initState();
    _currentLocation = Position(
        latitude: 19.3911668,
        longitude: -99.423815,
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
    _polygons = HashSet<Polygon>();
    getLocalesAll();
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

  Future<void> getLocalesAll() async {
    await getPasillos().then((value) async {
      for (var element in value.docs) {
        setState(() {
          _lista.add(Marker(
            markerId: MarkerId(_lista.length.toString()),
            position: LatLng(element["lat"], element["lng"]),
            infoWindow: InfoWindow(
              title: _lista.length.toString(),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onMapCreated(GoogleMapController controller) {
    controllerMap = controller;
    setCurrentLocation();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextFormField(
                  controller: controller1,
                ),
                TextFormField(
                  controller: controller2,
                ),
                finalizar(),
              ],
            )
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
          getLocalesAll();
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
      polygons: _polygons,
      //polylines: Set<Polyline>.of(polygons.values),
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
