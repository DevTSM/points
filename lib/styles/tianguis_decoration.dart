import 'package:flutter/material.dart';

abstract class TianguisDecoration {
  static BoxDecoration gold50 =
     BoxDecoration(
        color: Colors.yellow,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
      BoxShadow(
        color: Colors.yellow.shade100,
        offset: const Offset(3, 2),
        blurRadius: 10.0,
      ),
    ],);
    static BoxDecoration green50 =
     const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
      BoxShadow(
        color: Colors.grey,
        offset: const Offset(3, 2),
        blurRadius: 10.0,
      ),
    ],);
    static BoxDecoration red50 =
     const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
      BoxShadow(
        color: Colors.grey,
        offset: const Offset(3, 2),
        blurRadius: 10.0,
      ),
    ],);
}
