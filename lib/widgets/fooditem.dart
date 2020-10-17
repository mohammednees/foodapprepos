import 'package:flutter/material.dart';

class FoodItem extends StatefulWidget {
  String name;
  String imageUrl;
  String calori;
  IconButton add;
  IconButton sub;
  int qty;

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        color: Colors.amberAccent[100],
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              'https://images2.minutemediacdn.com/image/upload/c_crop,h_1126,w_2000,x_0,y_181/f_auto,q_auto,w_1100/v1554932288/shape/mentalfloss/12531-istock-637790866.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text('name'),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          print('back');
                        }),
                    Text('1'),
                    IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          print('forward');
                        }),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
