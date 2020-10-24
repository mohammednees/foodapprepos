import 'package:flutter/material.dart';
import 'package:foodapp/model/meals.dart';
import 'package:foodapp/model/order.dart';
import 'package:foodapp/model/user.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Order ord;
  // AuthResult authResult;
  String username;
  String lat;
  String long;

  TextEditingController phoneController = TextEditingController();

/*   Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      lat = locData.latitude.toString();
      long = locData.longitude.toString();
    } catch (error) {
      return 'open gps';
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<Meals>(context).items.values;
    var keyind = Provider.of<Meals>(context).items.values.toList();
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(height: 15.0),
        header(context),
        listMeals(cartItems, context),
        SizedBox(
          height: 10,
        ),
        totalandApplyOrder(context)
      ]),
    ));
  }

  Future<void> _showMyDialog() async {
    var txtvalue;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please write contact number and GPS location.'),
                TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    onChanged: (value) {
                      txtvalue = value;
                    }),
                IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: () async {
                      print('gps pressed');
                      //   await _getCurrentUserLocation();
                      Position position = await Geolocator().getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      print(position.latitude);
                      print(position.longitude);
                    })
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('yes'),
              onPressed: () {
                if (phoneController.text.length == 10) {
                  ord.storOrder(ord, context);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  print('wrong phone number');
                }
              },
            ),
            FlatButton(
              child: Text('no'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /* Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      lat = locData.latitude.toString();
      long = locData.longitude.toString();
      print(lat);
      print(long);
    } catch (error) {
      return 'open gps';
    }
  } */

  totalandApplyOrder(context) {
    return Container(
        child: Column(
      children: [
        Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              'Total = ' + Provider.of<Meals>(context).totalAmount.toString(),
              style: TextStyle(fontSize: 30, color: Colors.red),
            )),
        Container(
          width: 300,
          height: 50,
          margin: EdgeInsets.all(10),
          child: RaisedButton.icon(
              color: Colors.amber[300],
              onPressed: () async {
                var x;
                //   _getCurrentUserLocation();

                _showMyDialog();
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(
                        Provider.of<UserIformations>(context, listen: false).id)
                    .get()
                    .then((DocumentSnapshot) =>
                        x = DocumentSnapshot.data()['username'])
                    .whenComplete(
                      () => ord = Order(
                          DateTime.now(),
                          Provider.of<Meals>(context, listen: false).items,
                          x,
                          Provider.of<Meals>(context, listen: false)
                              .totalAmount,
                          '123345',
                          'null',
                          'null'),
                    );
              },
              icon: Icon(Icons.shopping_cart),
              label: Text('Order')),
        )
      ],
    ));
  }

  listMeals(cartItems, context) {
    return Container(
      height: 500,
      child: ListView.builder(
          itemCount: cartItems.length == null ? 0 : cartItems.length,
          itemBuilder: (ctx, ind) {
            return Dismissible(
              key: ValueKey(cartItems.toList()[ind]),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.amber)),
                        child: Text(
                          (ind + 1).toString(),
                          style: TextStyle(fontSize: 25),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    title: Text(
                      cartItems.toList()[ind].name,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blueGrey,
                          fontFamily: 'Bangers',
                          letterSpacing: 1.5),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Provider.of<Meals>(context, listen: false)
                                  .reduceQty(cartItems.toList()[ind].name);
                            }),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.amber)),
                                child: Text(
                                  cartItems.toList()[ind].qty.toString(),
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ))),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              Provider.of<Meals>(context, listen: false)
                                  .addItem(cartItems.toList()[ind].name,
                                      cartItems.toList()[ind].price, '');
                            }),
                      ],
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        (cartItems.toList()[ind].price *
                                cartItems.toList()[ind].qty)
                            .toString(),
                        style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
              ),
              background: Container(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text(
                      'Do you want to remove the item from the cart?',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                          Provider.of<Meals>(context, listen: false).removeItem(
                            cartItems.toList()[ind].name,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

  header(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      SizedBox(
        width: 100,
      ),
      Image.asset(
        'assets/images/app-pic.jpg',
        width: 50,
        height: 50,
      ),
      Text('Ramallah Rest.'),
      SizedBox(width: 50),
      IconButton(
        icon: Icon(Icons.cancel),
        iconSize: 30,
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.red,
      ),
      SizedBox(
        width: 50,
      )
    ]);
  }
}
