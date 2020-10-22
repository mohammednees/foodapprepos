import 'package:flutter/material.dart';
import 'package:foodapp/model/catagories.dart';

class FoodType extends StatelessWidget {
  Catagory _catagory;

  FoodType(this._catagory);

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
              color: _catagory.color,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                _catagory.imageUrl,
                fit: BoxFit.cover,
              ),
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
              _catagory.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
