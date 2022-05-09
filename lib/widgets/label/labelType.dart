import 'package:flutter/material.dart';
import 'package:points/styles/tianguis_decoration.dart';

Widget labelToken(String label){
  return Container(
    decoration: TianguisDecoration.gold50,
    padding: const EdgeInsets.only(top: 6,bottom: 6,right: 12,left: 12),
    child: Text(label),
  );
}