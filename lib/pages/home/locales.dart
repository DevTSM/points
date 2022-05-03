import 'package:flutter/material.dart';
import 'package:points/models/shop.dart';
import 'package:points/services/firebase_db_service.dart';
import 'package:points/widgets/card/shops/shopHome.dart';

class Locales extends StatefulWidget {
  const Locales({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocalesState();
}

class LocalesState extends State<Locales> {
  late List<ShopsModel> shops;
  @override
  void initState() {
    super.initState();
    shops = [];
    getDataShops();
  }

  getDataShops() async {
    shops = [];
    await getShops().then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          setState(() {
            shops.add(ShopsModel.fromFirebase(element));
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: shops.map((e) => ShopHomeCard(shopCurrent: e)).toList(),
          ),
        ));
  }
}
