import 'package:flutter/material.dart';
import 'package:points/pages/detalle_mapa.dart';
import 'package:points/points.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        backgroundColor: Colors.green,
      ),
      home: const MyHomePage(title: 'Mapa de Puntos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> points;

  @override
  void initState() {
    super.initState();
    points = [];
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

  Widget texto() {
    return Column(
      children: points.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: MapaDetalle()
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       texto(),
        //       boton()
        //     ],
        //   ),
        // ),
        );
  }
}
