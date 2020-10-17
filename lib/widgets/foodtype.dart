import 'package:flutter/material.dart';

class FoodType extends StatelessWidget {
  String name;
  Color color;
  Icon icon;

  FoodType({this.name, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Container(
          
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: color,
            ),
          ),
          Positioned(
            top: 0,
            left: 30,
            child: Container(
              height: 25,
              width: 120,
              child: Text(''),
              color: Colors.black54,
            ),
          ),
          Positioned(
            top: 3,
            left: 40,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
            ),
          )
        ],
      ),
    );
  }
}
