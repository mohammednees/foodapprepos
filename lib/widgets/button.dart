import 'package:flutter/material.dart';
import 'package:foodapp/model/meals.dart';
import 'package:provider/provider.dart';

class Quantitybtn extends StatefulWidget {
  Meal _meal;
  Quantitybtn(this._meal);
  @override
  QuantitybtnState createState() => QuantitybtnState();
}

class QuantitybtnState extends State<Quantitybtn> {
  bool clicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var mealsCart = Provider.of<Meals>(context, listen: false);

    if (!mealsCart.items.containsKey(widget._meal.name)) {
      clicked = false;
    } else {
      clicked = true;
    }

    if (!clicked) {
      return GestureDetector(
        onTap: () {
          mealsCart.addItem(widget._meal.name, widget._meal.price, 'addButton');
          setState(() {
            clicked = true;
            print(mealsCart.items[widget._meal.name].qty);
          });
        },
        child: Container(
          width: width * 0.22,
          height: width * 0.08,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: Text(
            'Add',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } else {
      return Container(
        height: width * 0.08,
        alignment: Alignment.center,
        width: width * 0.23,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: width * 0.08,
              height: width * 0.08,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5))),
              child: IconButton(
                icon: Icon(Icons.remove, color: Colors.black, size: 20),
                onPressed: () {
                  if (mealsCart.items[widget._meal.name].qty <= 1) {
                    setState(() {
                      clicked = false;
                      mealsCart.removeItem(widget._meal.name);
                    });
                  } else {
                    mealsCart.reduceQty(widget._meal.name);
                    print(mealsCart.items[widget._meal.name].qty);
                  }
                },
              ),
            ),
            Text(
              "${mealsCart.items[widget._meal.name].qty == null ? 1 : mealsCart.items[widget._meal.name].qty}",
              style: TextStyle(fontSize: 18),
            ),
            Container(
              width: width * 0.08,
              height: width * 0.08,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.black, size: 20),
                onPressed: () {
                  mealsCart.addItem(widget._meal.name, widget._meal.price, '');
                  print(mealsCart.items[widget._meal.name].qty);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
