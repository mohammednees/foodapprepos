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
  bool visibility = false;
  var count = 1;

  void _changed() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var mealsCart = Provider.of<Meals>(context, listen: false);

    return Visibility(
      visible: visibility,
      child: Container(
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
                  setState(() {
                    if (count == 1 || count < 1) {
                      count = 1;
                    } else {
                      count = count - 1;
                    }
                  });
                },
              ),
            ),
            Text(
              "$count",
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
                  setState(() {
                    count = count + 1;
                    mealsCart.addItem(widget._meal.name, widget._meal.price);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      replacement: GestureDetector(
        onTap: () {
          _changed();
           mealsCart.addItem(widget._meal.name, widget._meal.price);
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
      ),
    );
  }
}
