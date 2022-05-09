import 'package:flutter/material.dart';

Widget buttonDisable(Function function,Decoration decoration,TextStyle style,String label){
return GestureDetector(
  onTap: () => function(),
child:Container(
  decoration: decoration,
  padding: const EdgeInsets.only(top: 6,bottom: 6,right: 12,left: 12),
  child: Text(label,style: style,),
));
}