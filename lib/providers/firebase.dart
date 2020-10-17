import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/model/user.dart';

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
    try {
     
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      print(err);
    }
  }

  ////////////////////////////-Done-/////////////////////////////////////////
  Future<void> doneTask(String collectionPath, UserIformations user, String docid) async {
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

  ///////////////////////// PHONE AUTHENTICATION ///////////////////////////

}
