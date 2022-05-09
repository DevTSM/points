import 'package:flutter/material.dart';
import 'package:points/models/shop.dart';
import 'package:points/services/firebase_db_service.dart';
import 'package:points/styles/text_styles.dart';
import 'package:points/widgets/card/shops/shopHome.dart';

class Locales extends StatefulWidget {
  const Locales({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocalesState();
}

class LocalesState extends State<Locales> {
  late List<ShopsModel> shops;
  late int shopsA,shopsI,shopsN;
  @override
  void initState() {
    super.initState();
    shops = [];
    shopsA=0;
    shopsI=0;
    shopsN=0;
    getDataShops();
  }

  getDataShops() async {
    shops = [];
    await getShops().then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          setState(() {
            shops.add(ShopsModel.fromFirebase(element));
            if(shops.last.isAvailable){
              shopsA++;
            }else{
              shopsI++;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child:Column(
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "Tokens activos totales: ",style: TextStyles.black16),
                      TextSpan(text: "  $shopsA",style: TextStyles.green16)
                    ]
                  )),
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "Tokens inactivos totales: ",style: TextStyles.black16),
                      TextSpan(text: "  $shopsI",style: TextStyles.red16)
                    ]
                  )),
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "Tokens nuevos: ",style: TextStyles.black16),
                      TextSpan(text: "  $shopsN",style: TextStyles.green16)
                    ]
                  ))
                ],
              ),
            ),
            SingleChildScrollView(
          child: Column(
            children: shops.map((e) => ShopHomeCard(shopCurrent: e)).toList(),
          ),
        )
          ],
        ));
  }
}
