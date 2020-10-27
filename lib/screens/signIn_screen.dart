import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/model/user.dart';
import 'package:foodapp/providers/firebase.dart';
import 'package:foodapp/screens/home.dart';
import 'package:foodapp/screens/start_page.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  User user;
  final _auth = FirebaseAuth.instance;
  UserCredential authResult;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _phoneController2 = TextEditingController();
  String selectedValue = '+972';
  FirebaseFunc firebase = FirebaseFunc();
  final _phonefocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  _signOut() async {
    await _auth.signOut();
  }

  @override
  void initState() {
    _phoneController2.text = '';

    // _signOut(); // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userinfo = Provider.of<UserIformations>(context, listen: false);
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
                _isLoading = false;
                userinfo.id = FirebaseAuth.instance.currentUser.uid;
        

                userinfo.phoneNo =
                    FirebaseAuth.instance.currentUser.phoneNumber;
                print(userinfo.id);
                firebase.setDataWhenInit(
                    'users', userinfo.id, userinfo.phoneNo, context);
                return StartPage();
              } else if (_isLoading) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text('Please wait code'),
                      SizedBox(height: 2),
                      CircularProgressIndicator()
                    ]));
              } else if (!_isLoading)
                return Center(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              color: Colors.grey[50],
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      headerText(),
                                      SizedBox(height: 20),
                                      phoneTextField(),
                                      SizedBox(height: 20),
                                      signInButton(context),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ))));
            }));
  }

/////////////////////-Widgets-/////////////////////////////
  headerText() {
    return Text('Welcome',
        style: TextStyle(fontSize: 40, color: Colors.grey[500]));
  }

  phoneTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 120,
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          child: DropdownButton<String>(
            underline: SizedBox(),
            isExpanded: true,
            items: <String>["+970", "+972", "+962"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            //hint:Text(selectedValue),
            value: selectedValue,
            onChanged: (newVal) {
              setState(() {
                selectedValue = newVal;
              });
            },
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 200,
          child: TextFormField(
            key: ValueKey('phone'),
            controller: _phoneController,
            focusNode: _phonefocus,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'Phone Number'),
            validator: (value) {
              if (value.isEmpty || value.length != 9) {
                return 'please enter valid Phone Number';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  signInButton(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isLoading = true;
        });

        final phone = selectedValue + _phoneController.text.trim();

        loginUser(phone, context);
      },
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.blue[700], Colors.blue[200]]),
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                )),
          ),
          Positioned(
            right: 10,
            top: 5,
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Icon(Icons.arrow_forward)),
          ),
          Positioned(
            right: 120,
            top: 13,
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }

  /////////// PHONE AUTH ////////////

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          user = result.user;

          if (user != null) {
            String userId = FirebaseAuth.instance.currentUser.uid;
            String phone = FirebaseAuth.instance.currentUser.phoneNumber;

            firebase.setDataWhenInit('users', userId, phone, context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => StartPage()));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Please enter code when recive"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _phoneController2,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _phoneController2.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        user = result.user;

                        if (user != null) {
                          String userId = FirebaseAuth.instance.currentUser.uid;
                          String phone =
                              FirebaseAuth.instance.currentUser.phoneNumber;

                          firebase.setDataWhenInit(
                              'users', userId, phone, context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StartPage()));
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
