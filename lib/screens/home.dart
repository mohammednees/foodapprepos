import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/model/catagories.dart';
import 'package:foodapp/model/meals.dart';
import 'package:foodapp/model/user.dart';
import 'package:foodapp/providers/firebase.dart';
import 'package:foodapp/screens/cart_screen.dart';
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
  Map<String, Meal> meals;
  List<Catagory> catagoris;
  int _catagoryIndex = 0;

  _signOut() async {
    await _auth.signOut();
  }

  @override
  void initState() {
    _getMeals();
    _getCatagories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var meals = Provider.of<Meals>(context, listen: false)
        .filterItems(catagoris[_catagoryIndex].name);
    
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
              SizedBox(width: 50),
              Row(
                children: [
                  Image.asset(
                    'assets/images/app-pic.jpg',
                    width: 50,
                    height: 50,
                  ),
                  Text('Ramallah Rest.')
                ],
              ),
              SizedBox(width: 50),
              GestureDetector(
                onTap: () {
               
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ));
                },
                child: Badge(
                    color: Colors.yellow,
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 40,
                    ),
                    value: Provider.of<Meals>(context).items.length.toString()),
              ),
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
                itemCount: catagoris.length,
                itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _catagoryIndex = index;
                       
                      });
                    },
                    child: FoodType(catagoris[index]))),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              height: MediaQuery.of(context).size.height / 1.5,
              color: Colors.amberAccent[100],
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: meals.length == null ? 0 : meals.length,
                itemBuilder: (context, index) {
                  return FoodItem(meals[index]);
                  //  return FoodItem(x[index]);
                },
              ))
        ],
      )),
    );
  }

  /////////////////////// Get Meals ///////////////////

  void _getMeals() {
    meals = Provider.of<Meals>(context, listen: false).serveritems;
  }

  void _getCatagories() {
    catagoris = Provider.of<Catagories>(context, listen: false).items;
  }
}
