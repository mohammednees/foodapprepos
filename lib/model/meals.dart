import 'package:flutter/cupertino.dart';

class Meal with ChangeNotifier {
  String _name;
  double _price;
  int _qty;
  int _calories;
  int _time;
  bool _isFavorite;
  String _imageUrl;
  String _discription;

  Meal(this._name, this._price,
      [this._qty = 1,
      this._imageUrl,
      this._calories,
      this._isFavorite = false,
      this._time,
      this._discription]);

  set name(String val) {
    this._name = val;
  }

  set price(double val) {
    this._price = val;
    notifyListeners();
  }

  set qty(int val) {
    this._qty = val;
    notifyListeners();
  }

  set isFavorite(bool val) {
    this._isFavorite = val;
  }

  int get calories => _calories;
  int get time => _time;

  set time(int value) => _time = value;
  set calories(int value) => _calories = value;
  String get name => _name;
  double get price => _price;
  int get qty => _qty;
  bool get isFavorite => _isFavorite;
  String get image => _imageUrl;
  String get discription => _discription;

  set discription(String value) => _discription = value;

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

class Meals with ChangeNotifier {
  Map<String, Meal> _items = {
    'big burger': Meal(
        'big burger',
        20.0,
        1,
        'https://storcpdkenticomedia.blob.core.windows.net/media/recipemanagementsystem/media/recipe-media-files/recipes/retail/x17/2019_df_retail_butter-burger_20912_760x580.jpg?ext=.jpg',
        250,
        false,
        30,
        'good food'),
    'small burger': Meal(
        'small burger',
        10.0,
        1,
        'https://storcpdkenticomedia.blob.core.windows.net/media/recipemanagementsystem/media/recipe-media-files/recipes/retail/x17/2019_df_retail_butter-burger_20912_760x580.jpg?ext=.jpg',
        250,
        false,
        15,
        'contains of some good hot spicy food'),
  };

  Map<String, Meal> get items {
    return {..._items};
  }

  void storeEditedMap(Map<dynamic, dynamic> map) {
    // var xxx;
    map.forEach((key, value) {
      _items.putIfAbsent(
        key,
        () => Meal(key, value['price'], value['qty'], value['imageUrl']),
      );
    });
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qty;
    });
    return total;
  }

  void addItem(
    String name,
    double price,
    bool arrow,
  ) {
    if (_items.containsKey(name)) {
      // change quantity...
      _items.update(
        name,
        (existingCartItem) => Meal(
          existingCartItem.name,
          existingCartItem.price,
          existingCartItem.qty + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        name,
        () => Meal(name, price, 1),
      );
    }
    notifyListeners();
  }

  void addpurchaseitem(
    String name,
    double price,
    int qty,
  ) {
    _items.putIfAbsent(
      name,
      () => Meal(name, price, qty),
    );

    notifyListeners();
  }

  void removeItem(String name) {
    _items.remove(name);
    notifyListeners();
  }

  void reduceQty(String name) {
    if (_items.containsKey(name)) {
      _items.update(
        name,
        (existingCartItem) => Meal(
          existingCartItem.name,
          existingCartItem.price,
          existingCartItem.qty - 1,
        ),
      );
    }

    _items.removeWhere((key, value) => value.qty == 0);

    notifyListeners();
  }
}
