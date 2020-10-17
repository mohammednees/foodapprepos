import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthSign  {
  bool _isLoading;

  void emailandPassword(
    String email,
    String password,
    String logintype,
    bool isLogin,
  ) async {
    final _auth = FirebaseAuth.instance;
    try {
      var authresut = await _auth.createUserWithEmailAndPassword(
        email: 'email@aa.com',
        password: 'password',
      );

      /*   await FirebaseFirestore.instance
            .collection('user')
            .doc(authResult.user.uid)
            .set({
          'username': logintype,
          'email': email,
          'userType': logintype,
        });
        print(authResult.user.uid);*/

    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      _isLoading = false;
    } catch (err) {
      print(err);
    }
  }
}
