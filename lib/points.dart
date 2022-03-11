import 'package:flutter/material.dart';
import 'package:points/main.dart';
import 'package:points/services/firebase_db_service.dart';
import 'package:geolocator/geolocator.dart';

class SecondaryPage extends StatefulWidget {
  const SecondaryPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SecondaryPage> createState() => _SecondaryPageState();
}

class _SecondaryPageState extends State<SecondaryPage> {
  late String datoGuardado;
  late List<Map<String, dynamic>> points;
  late List<Widget> pointsView;

  @override
  void initState() {
    super.initState();
    datoGuardado = 'Coordenadas';
    points = [];
    pointsView = [];
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
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  const MyHomePage(title: 'Principal'),
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        // ignore: unnecessary_new
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * .6,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pointsView.toList())),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            finalizar(),
          ],
        ));
  }
}
