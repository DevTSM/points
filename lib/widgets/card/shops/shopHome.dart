import 'package:flutter/material.dart';
import 'package:points/models/shop.dart';
import 'package:points/pages/locales/details_shop.dart';
import 'package:points/styles/text_styles.dart';
import 'package:points/widgets/label/labelType.dart';

class ShopHomeCard extends StatefulWidget {
  ShopsModel shopCurrent;
  ShopHomeCard({Key? key, required this.shopCurrent}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShopHomeCardState();
}

class ShopHomeCardState extends State<ShopHomeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    DetailShop(shop: widget.shopCurrent),
              )),
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              children: [
                Image.network(
                    widget.shopCurrent.multimedia.first,
                    width: 80,fit: BoxFit.cover,),
                const SizedBox(width: 10,),
                Expanded(flex: 7, child: Text(widget.shopCurrent.name)),
                widget.shopCurrent.isPrime?labelToken("Premiun"):Container(),
                const SizedBox(width: 70,),
                Expanded(
                    child: Text(
                        widget.shopCurrent.isAvailable ? "Activo" : "Inactivo",style: widget.shopCurrent.isAvailable ?TextStyles.green16:TextStyles.red16,))
              ],
            ),
          )),
    );
  }
}
