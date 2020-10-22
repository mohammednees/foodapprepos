import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/model/catagories.dart';
import 'package:foodapp/model/meals.dart';
import 'package:foodapp/model/user.dart';
import 'package:foodapp/providers/firebase.dart';
import 'package:foodapp/screens/home.dart';
import 'package:foodapp/screens/splash_screens.dart';
import 'package:foodapp/screens/start_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => FirebaseFunc(),
              ),
              ChangeNotifierProvider(
                create: (context) =>
                    UserIformations('', null, '', '', '', 0, false),
              ),
              ChangeNotifierProvider(
                create: (context) => Meals(),
              ),
              ChangeNotifierProvider(
                create: (context) => Meal('', 0),
              ),
              ChangeNotifierProvider(
                create: (context) => Catagories(),
              ),
              ChangeNotifierProvider(
                create: (context) => Catagory('', '', null),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'myapp',
              home: HomeApp(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StartPage(),
    );
  }
}
