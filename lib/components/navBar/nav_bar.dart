import 'package:flutter/material.dart';

class NavigationBarWeb extends StatelessWidget {
  const NavigationBarWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Text(
            'Inicio',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(width: 100.0),
          Text(
            'Locales',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(width: 100.0),
          Text(
            'Contact',
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
        ],
      )
    );
  }
}
