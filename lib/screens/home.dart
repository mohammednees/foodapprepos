import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/model/user.dart';
import 'package:foodapp/providers/firebase.dart';
import 'package:foodapp/widgets/badge.dart';
import 'package:foodapp/widgets/fooditem.dart';
import 'package:foodapp/widgets/foodtype.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  _signOut() async {
    await _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userinfo = Provider.of<UserIformations>(context, listen: false);

    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.power_settings_new_outlined, size: 40),
                  onPressed: () {
                    _signOut();
                  }),
              Image.asset(
                'assets/images/app-pic.jpg',
                width: 50,
                height: 50,
              ),
              Badge(
                  color: Colors.yellow,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 40,
                  ),
                  value: '3'),
            ],
          ),
          Divider(
            height: 4,
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) => FoodType(
                      name: 'food',
                      color: Colors.amber,
                      icon: Icon(Icons.food_bank),
                    )),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            color: Colors.amberAccent,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 3,
                itemBuilder: (context, index) => FoodItem()),
          )
        ],
      )),
    );
  }
}
