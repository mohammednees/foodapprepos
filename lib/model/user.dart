import 'package:flutter/cupertino.dart';

class UserIformations with ChangeNotifier {
  String _id;

  String _name;
  String phoneNo;

  DateTime _createTime;
  String address;
  double _total;
  bool _done;

  UserIformations(this._id, this._createTime, this._name, this.phoneNo,
      this.address, this._total,
      [this._done = false]);

  String get getPhoneNo => phoneNo;

  set setPhoneNo(String phoneNo) => this.phoneNo = phoneNo;

  String get id => _id;

  set id(String value) => _id = value;

  String get name => _name;

  set name(String value) => _name = value;

  String get getAddress => address;

  set setAddress(String address) => this.address = address;

  double get total => _total;

  set total(double value) => _total = value;

  bool get done => _done;

  set done(bool value) => _done = value;
}
