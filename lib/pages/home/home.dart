// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:points/pages/detalle_mapa.dart';

class HomePrincipal extends StatefulWidget {
  int index;
  HomePrincipal({Key? key, this.index = 0}) : super(key: key);
  @override
  _HomePrincipalState createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  late Size size;
  late int indexCurrent;
  @override
  void initState() {
    super.initState();
    size = const Size(0, 0);
    indexCurrent = 0;
  }

  void joinPage(int index) {
    setState(() {
      indexCurrent = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    return Scaffold(
        body: Stack(
      children: [
        MapaDetalle(index: indexCurrent),
        Container(
            child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'General',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Nodos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Trazado',
            ),
          ],
          currentIndex: indexCurrent,
          selectedItemColor: Colors.amber[800],
          onTap: joinPage,
        ))
      ],
    ));
  }
}
