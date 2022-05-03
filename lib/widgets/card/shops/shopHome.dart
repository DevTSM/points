import 'package:flutter/material.dart';
import 'package:points/models/shop.dart';
import 'package:points/pages/locales/details_shop.dart';

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
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: Row(
              children: [
                // Image.network(
                //     "https://www.tcgroupsolutions.com/wp-content/uploads/2021/03/retail-intelligence-tc-street-2.png"),
                Expanded(flex: 4, child: Text(widget.shopCurrent.name)),
                Expanded(
                    child: Text(
                        widget.shopCurrent.isAvailable ? "Activo" : "Inactivo"))
              ],
            ),
          )),
    );
  }
}
