import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:points/pages/detalle_mapa.dart';
import 'package:points/pages/home/home.dart';
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
    return OKToast(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        backgroundColor: Colors.green,
      ),
      home: HomePrincipal(),
    ));
  }
}
