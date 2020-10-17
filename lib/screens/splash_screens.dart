import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/screens/signIn_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation animation;
  Animation delayedAnimation;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastLinearToSlowEaseIn));
    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastLinearToSlowEaseIn)));
    animationController.forward();
    _initSplashScreen();
    super.initState();
  }

  void _initSplashScreen() {
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SignInScreen())));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Center(
              child: Transform(
                transform: Matrix4.translationValues(
                    animation.value * width, 0.0, 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50, left: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform(
                            transform: Matrix4.translationValues(
                                animation.value * width, 0.0, 0.0),
                            child: Text('Ramallah Burger',
                                style: TextStyle(
                                    fontSize: 35, color: Colors.blue))),
                        Transform(
                            transform: Matrix4.translationValues(
                                delayedAnimation.value * width, 0.0, 0.0),
                            child: Image.asset(
                              'assets/images/app-pic.jpg',
                              width: 200,
                              height: 200,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
