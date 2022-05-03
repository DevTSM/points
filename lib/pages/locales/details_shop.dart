//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:points/models/shop.dart';

class DetailShop extends StatefulWidget {
  ShopsModel shop;
  DetailShop({Key? key, required this.shop}) : super(key: key);

  @override
  State<DetailShop> createState() => DetailShopState();
}

class DetailShopState extends State<DetailShop> {
  late List<Map<String, dynamic>> calificaciones;

  @override
  void initState() {
    super.initState();
    calificaciones = [];
    getCalificaciones();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCalificaciones() async {
    // await getCalificacionesLocal(widget.shop.id)
    //     .then((value) => value.docs.forEach((element) {
    //           setState(() {
    //             calificaciones.add(element.data() as Map<String, dynamic>);
    //           });
    //         }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: ColorStyles.vendedor,
        toolbarHeight: 5,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            // widget.shop.multimedia.length > 0
            //     ? carrouselImg()
            //     :
            Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width - 40,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        "https://png.pngtree.com/element_our/png_detail/20181124/shop-vector-icon-png_246574.jpg",
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
            Expanded(child: details()),
            botonMapa()
          ],
        ),
      ),
    );
  }

  Widget comentarios() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: calificaciones.length,
        itemBuilder: (context, position) {
          final Map<String, dynamic> item = calificaciones[position];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 5, left: 5),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      item["tituloComentario"],
                    ),
                    Text(item["comentario"]),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 30,
                      width: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: item["estrellas"],
                        itemBuilder: (BuildContext context, int index) {
                          return calificacionComentario();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget carrouselImg() {
  //   return CarouselSlider(
  //     options: CarouselOptions(
  //       height: MediaQuery.of(context).size.height * .23,
  //       onPageChanged: (index, reason) {},
  //       viewportFraction: 1,
  //       autoPlayAnimationDuration: const Duration(milliseconds: 100),
  //       autoPlay: true,
  //       enlargeCenterPage: true,
  //     ),
  //     items: widget.shop.multimedia
  //         .map((item) => GestureDetector(
  //             child: Container(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     height: MediaQuery.of(context).size.height * .2,
  //                     width: MediaQuery.of(context).size.width - 40,
  //                     decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                             image: NetworkImage(
  //                               item,
  //                             ),
  //                             fit: BoxFit.cover),
  //                         borderRadius:
  //                             const BorderRadius.all(Radius.circular(15.0))),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             onTap: () {}))
  //         .toList(),
  //   );
  // }

  Widget details() {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.shop.name} "),
                    //calificacionTienda()
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("CATEGORIAS"),
          Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.shop.category.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(widget.shop.category[index].name),
                  );
                },
              )),
          calificaciones.isNotEmpty
              ? Expanded(child: comentarios())
              : const Expanded(
                  child: Center(child: Text("Sin Comentarios")),
                ),
        ],
      ),
    );
  }

  Widget botonMapa() {
    return GestureDetector(
        // onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute<void>(
        //         builder: (BuildContext context) => MapaDetalle(
        //           type: 1,
        //           localCurrent: widget.tienda,
        //         ),
        //       ),
        //     ),
        child: Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: 50,
      width: 330,
      child: const Center(
        child: Text(
          'VER EN EL MAPA',
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }

  Widget calificacionComentario() {
    return Icon(
      Icons.star,
      color: Colors.yellow[700],
      size: 20,
    );
  }

  // Widget calificacionTienda() {
  //   return Container(
  //       //width: MediaQuery.of(context).size.width - 30,
  //       height: 10,
  //       margin: const EdgeInsets.only(bottom: 10),
  //       color: Colors.transparent,
  //       child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: widget.shop.qualify,
  //           itemBuilder: (context, position) {
  //             return Icon(
  //               Icons.star,
  //               color: Colors.yellow[700],
  //               size: 30,
  //             );
  //           }));
  // }
}
