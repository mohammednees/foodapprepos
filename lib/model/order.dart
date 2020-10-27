import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/model/meals.dart';
import 'package:foodapp/model/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Order {
  String id;
  DateTime createAt;
  Map<String, Meal> mealitems;
  Map<String, Meal> purchaseitems;
  String userName;
  String userPhone;
  double total;
  String latPosition;
  String longPosition;

  Map<String, dynamic> xxx = {};

  Order(this.createAt, this.mealitems, this.userName, this.total,
      [this.userPhone, this.latPosition, this.longPosition]);

  void storOrder(Order ord, BuildContext context) async {
    var map = mealitems;
    // var phone = Provider.of<UserIformations>(context, listen: false).phoneNo;
    var phone = Provider.of<UserIformations>(context, listen: false).phoneNo;
    var customerID = Provider.of<UserIformations>(context, listen: false).id;

    map.forEach((key, value) {
      convert(key, value);
    });

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      await FirebaseFirestore.instance.collection('order').doc(customerID).set({
        'username': userName,
        'creatAt': createAt,
        'total': total,
        'meallist': xxx,
        'phoneNumber': phone,
        'latPosition': value.latitude.toString(),
        'longPosition': value.longitude.toString(),
        'isdelivered': 'false'
      });
    });
  }

  void convert(String x, Meal meal) {
    xxx.putIfAbsent(
        x,
        () => {
              'price': meal.price,
              'qty': meal.qty,
            });
  }
}
