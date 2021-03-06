import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/model/catagories.dart';
import 'package:foodapp/model/meals.dart';
import 'package:foodapp/model/user.dart';
import 'package:provider/provider.dart';

class FirebaseFunc with ChangeNotifier {
  /////////////////////////-SET DATA-/////////////////////////////////////////
  Future<void> setDataWhenInit(
      String collectionPath, String user, String phoneNumber, context) async {
    ////////// check id user already exist ////////////////////
    ///
    ///

    Map<String, Meal> xxx = {};
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((value) {
      if (value.exists) {
        try {
          FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(Provider.of<UserIformations>(context, listen: false).id)
              .update({
            'name': user,
            'createAt': DateTime.now(),
            'phoneNumber': phoneNumber,
          });
        } on PlatformException catch (err) {
          var message = 'An error occurred, pelase check your credentials!';

          if (err.message != null) {
            message = err.message;
          }
        } catch (err) {
          print(err);
        }
      } else {
        try {
          FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(Provider.of<UserIformations>(context, listen: false).id)
              .set({
            'name': user,
            'createAt': DateTime.now(),
            'phoneNumber': phoneNumber,
            'favorite': xxx
          });
        } on PlatformException catch (err) {
          var message = 'An error occurred, pelase check your credentials!';

          if (err.message != null) {
            message = err.message;
          }
        } catch (err) {
          print(err);
        }
      }
    });
  }

  Future<void> updatedatawhenlogin(
      String collectionPath, String user, String phoneNumber, context) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(Provider.of<UserIformations>(context, listen: false).id)
          .update({
        'name': user,
        'createAt': DateTime.now(),
        'phoneNumber': phoneNumber,
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
  }

////////////////////////////-UPDATE-/////////////////////////////////////////
  Future<void> updateData(
      String collectionPath, UserIformationstask, String docid) async {
    try {} on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
  }

  ////////////////////////////-Done-/////////////////////////////////////////
  Future<void> doneTask(
      String collectionPath, UserIformations user, String docid) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docid)
          .update({
        'done': true,
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
  }

/////////////////////////-DELETE DATE-///////////////////////////////////////
  Future<void> deleteData(String collectionPath, String docID) async {
    try {
      FirebaseFirestore.instance.collection(collectionPath).doc(docID).delete();
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
  }

  /////////////////////////Read Catagories/////////////////////////////////////////
  Future<List<Catagory>> readCatagories() async {
    List<Catagory> catagory = [];
    try {
      await FirebaseFirestore.instance
          .collection('catagories')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          catagory.add(Catagory(element.data()['name'],
              element.data()['imageUrl'], Color(0xFF99A5a8)));
        });
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }

    return catagory;
  }

  /////////////////////////Read Meals/////////////////////////////////////////
  Future<Map<String, dynamic>> readMeals(BuildContext context) async {
    var _meals = Provider.of<Meals>(context, listen: false).serveritems;

    try {
      await FirebaseFirestore.instance.collection('meals').get().then((value) {
        value.docs.forEach((element) {
          double doublevalue = double.parse(element.data()['price']);
          _meals.putIfAbsent(
              element.data()['name'],
              () => Meal(
                    element.data()['name'],
                    doublevalue,
                    element.data()['qty'],
                    element.data()['imageUrl'],
                    element.data()['calories'],
                    false,
                    element.data()['time'],
                    element.data()['description'],
                    element.data()['catagory'],
                  ));
        });
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
    Provider.of<Meals>(context, listen: false).serveritems = _meals;

    return _meals;
  }

///////////////////////READ FAVOREITE MEALS //////////////////////////////////
  ///
  Future<Map<String, dynamic>> readFavoriteMeals(BuildContext context) async {
    var _favorite = Provider.of<Meals>(context, listen: false).serveritems;
/////////////////////////////GET ALL ITEMS LIST //////////////////////
    try {
      await FirebaseFirestore.instance.collection('meals').get().then((value) {
        value.docs.forEach((element) {
          double doublevalue = double.parse(element.data()['price']);
          _favorite.putIfAbsent(
              element.data()['name'],
              () => Meal(
                    element.data()['name'],
                    doublevalue,
                    element.data()['qty'],
                    element.data()['imageUrl'],
                    element.data()['calories'],
                    false,
                    element.data()['time'],
                    element.data()['description'],
                    element.data()['catagory'],
                  ));
        });
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
    //////////////////// GET FAV FOOD FROM USER ////////////////////
    Map<String, dynamic> _map = {};
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<UserIformations>(context, listen: false).id)
          .get()
          .then((value) {
        _map = value.data()['favorite'] == null ? {} : value.data()['favorite'];
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }

    Map<String, Meal> _finalMap = {};

    _favorite.forEach((key, value) {
      if (_map.containsKey(key)) {
        _finalMap.putIfAbsent(key, () => value);
      }
    });
    print(_finalMap);

    Provider.of<Meals>(context, listen: false).serveritems = _finalMap;

    return _finalMap;
  }

  ///////////////////ADD FAVORITE TO USER //////////////////
  ///
  Future<void> addFavorite(String name, context) async {
    Map<String, dynamic> xxx = {};
    Map<String, dynamic> yyy = {};

    try {
    await  FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<UserIformations>(context, listen: false).id)
          .get()
          .then((value) {
        yyy = value.data()['favorite'];
        yyy.putIfAbsent(name, () => name);
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }

    try {
    await  FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<UserIformations>(context, listen: false).id)
          .update(
        {
          'favorite': yyy,
        },
      );
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
  }
}
