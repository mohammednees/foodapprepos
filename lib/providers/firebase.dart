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
      String collectionPath, String user, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance.collection(collectionPath).doc().set({
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
}
