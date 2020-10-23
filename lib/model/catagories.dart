import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Catagory with ChangeNotifier {
  String _name;
  String _imageUrl;
  Color _color;

  Catagory(this._name, this._imageUrl, this._color);

  String get name => _name;

  set name(String value) => _name = value;

  set color(Color value) => _color = value;

  Color get color => _color;

  String get imageUrl => _imageUrl;

  set imageUrl(String value) => _imageUrl = value;
}

class Catagories with ChangeNotifier {
  List<Catagory> _items = [
    /*   Catagory(
      'Burger',
      'https://www.simplyrecipes.com/wp-content/uploads/2018/06/HT-Grill-Burger-LEAD-VERTICAL.jpg',
      Color(0xFF42d5F1),
    ),
    Catagory(
      'Ckicken',
      'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/20191011-keto-fried-chicken-delish-ehg-2642-1571677665.jpg',
      Color(0xFF99A5a8),
    ),
    Catagory(
      ' Salad',
      'https://www.cookingclassy.com/wp-content/uploads/2019/11/best-salad-7.jpg',
      Color(0xFF02A5a8),
    ) */
  ];
  List<Catagory> get items {
    return _items;
  }

  set items(List<Catagory> value) => _items = value;

  void addfromServer(Catagory cat) {
    _items.add(cat);
  }
}
