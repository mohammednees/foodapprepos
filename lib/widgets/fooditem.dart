import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/model/meals.dart';
import 'package:foodapp/providers/firebase.dart';
import 'package:foodapp/widgets/button.dart';
import 'package:foodapp/widgets/item_page.dart';

class FoodItem extends StatefulWidget {
  Meal _meal;
  FoodItem(this._meal);
  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          print('go items page');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemPage(widget._meal),
              ));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black54)),
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                widget._meal.image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget._meal.name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.alarm,
                        color: Colors.blue,
                      ),
                      Text(
                        widget._meal.time.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(width: 20),
                      Text(
                        widget._meal.price.toString() + '\$',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget._meal.calories.toString() + 'KCal',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Quantitybtn(widget._meal),
                        IconButton(
                            icon: Icon(Icons.star),
                            color: Colors.grey,
                            onPressed: () {
                              print('pressed');
                              FirebaseFunc firebase = FirebaseFunc();
                              firebase.addFavorite(widget._meal.name, context);
                            })
                      ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
