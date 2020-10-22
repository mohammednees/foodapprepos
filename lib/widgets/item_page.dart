import 'package:flutter/material.dart';
import 'package:foodapp/model/meals.dart';

class ItemPage extends StatefulWidget {
  Meal _meal;

  ItemPage(this._meal);
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool _checkVal = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.height;
    double expandHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(
                    widget._meal.name,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  expandedHeight: expandHeight,
                  //floating: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.grey[800],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  //  forceElevated: innerBoxIsScrolled,
                  pinned: true,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  // actionsIconTheme: IconThemeData(opacity: 0.0),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      height: expandHeight,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Image.network(widget._meal.image,

                              /// check null value
                              width: width,
                              height: 400,
                              fit: BoxFit.cover)
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            /////////////////////////////////////////////////////////////////////
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget._meal.discription.toString()),
                        Text(widget._meal.price.toString()),
                        Text(widget._meal.calories.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.alarm, color: Colors.blue),
                            Text(widget._meal.time.toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                value: _checkVal,
                                onChanged: (value) {
                                  setState(() {
                                    _checkVal = value;
                                  });
                                }),
                            Text('Spicy'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
