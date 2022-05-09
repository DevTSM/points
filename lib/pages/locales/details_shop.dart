//import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:points/models/shop.dart';
import 'package:points/services/firebase_db_service.dart';
import 'package:points/styles/text_styles.dart';
import 'package:points/styles/tianguis_decoration.dart';
import 'package:points/widgets/buttons/button_disable.dart';

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
  disableFunction() async {
    await updateDisableShop(widget.shop.id, widget.shop.updateDisable()).then((value){
      setState(() {
        widget.shop=widget.shop;
      });
    });
  }
  showDelete(String url){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Eliminar multimedia"),
            content: const Text('¿Quieres eliminar la imagen?'),
            actions: <Widget>[
              Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'))),Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () {
                          widget.shop.deleteImage(url);
                          setState(() {
                            widget.shop=widget.shop;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Si'),
                      ))
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height - 5,
        child:SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child:Text(widget.shop.name,textAlign: TextAlign.center,)),
                RichText(text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Fecha de caducidad :",style: TextStyles.black16
                    ),
                    TextSpan(
                      text: "  ${DateFormat('dd/MM/yyyy').format(widget.shop.expiration)}",style: TextStyles.black16
                    )
                  ]
                )),
                const SizedBox(
                  width: 10,
                ),
                buttonDisable(disableFunction,widget.shop.isAvailable?TianguisDecoration.red50:TianguisDecoration.green50,TextStyles.white165,widget.shop.isAvailable?"Desactivar":"Activar", ),
                const SizedBox(
                width: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width-30,
              child:SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.shop.multimedia.map((e) => Row(children:[
                  Stack(children:[Image.network(e,height: 400,),
                  IconButton(onPressed: (){
                    showDelete(e);
                  }, icon: const Icon(Icons.delete_forever,color: Colors.red,))]),
                  SizedBox(width: widget.shop.multimedia.indexOf(e)==widget.shop.multimedia.length+1?0: 20,)])).toList(),
              ),
            )),
             const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            color: Colors.grey,
            child:const Text("CATEGORIAS")),
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
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            color: Colors.grey,
            child:const Text("COMENTARIOS")),
          calificaciones.isNotEmpty
              ? comentarios()
              : const Center(child: Text("Sin Comentarios")),
          ],
        )),
      ),
    );
  }

  Widget comentarios() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: Column(
        children: calificaciones.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 5, left: 5),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      e["tituloComentario"],
                    ),
                    Text(e["comentario"]),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 30,
                      width: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: e["estrellas"],
                        itemBuilder: (BuildContext context, int index) {
                          return calificacionComentario();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )).toList(),
      )
    );
  }

  Widget calificacionComentario() {
    return Icon(
      Icons.star,
      color: Colors.yellow[700],
      size: 20,
    );
  }

}
