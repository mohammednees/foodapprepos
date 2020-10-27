import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodapp/model/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CustomerLocationMap extends StatefulWidget {
  @override
  _CustomerLocationMapState createState() => _CustomerLocationMapState();
}

class _CustomerLocationMapState extends State<CustomerLocationMap> {
  bool onlyonce = true;
  GoogleMapController mapController;
  Position customerDestenation;
  Position driverDestnation;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<Position> pos = [
    Position(latitude: 31.923746, longitude: 35.216969),
    Position(latitude: 31.920926, longitude: 35.207294),
    Position(latitude: 31.916559, longitude: 35.206934)
  ];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyBhb_xtk3doA9uN4d8gzB0o99h0_6R1fE0';
/////////////////////////////////////////////////////////////////////////////////
  /* Future<Position> getGeoPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  } */
///////////////////////////////////////////////////////////////////////////////////

  _handleTap(LatLng tappedPoint) {
    markers = {};
    driverDestnation = Position(
        latitude: tappedPoint.latitude, longitude: tappedPoint.longitude);
    _addMarker(
        tappedPoint, 'driver', BitmapDescriptor.defaultMarkerWithHue(90));

    print(tappedPoint.latitude);
    print(tappedPoint.longitude);

    //  _getPolyline();
  }

/////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

//////////////////////////////////////////////////////////////////////////////////////
    /*  /// origin marker
    _addMarker(LatLng(driverDestnation.latitude, driverDestnation.latitude),
        "origin", BitmapDescriptor.defaultMarker);
/////////////////////////////////////////////////////////////////////////////////////////
    /// destination marker
    _addMarker(
        LatLng(customerDestenation.latitude, customerDestenation.longitude),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline(); */
  }

////////////////////////////////////////////////////////////////////////////////////////
  void _onMapCreated(GoogleMapController controller) async {
    if (onlyonce) {
      mapController = controller;

      /*    Timer(
          Duration(seconds: 3),
          () => _addMarker(
              LatLng(
                  customerDestenation.latitude, customerDestenation.longitude),
              'customer',
              BitmapDescriptor.defaultMarkerWithHue(90))); */
    }

    onlyonce = false;
  }

//////////////////////////////////////////////////////////////////////////////////////
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    // setState(() {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      position: position,
      draggable: true,
      markerId: markerId,
      icon: descriptor,
    );
    markers[markerId] = marker;
    // polylines.clear();
    polylineCoordinates.clear();
    _getPolyline();
    // });
  }

/////////////////////////////////////////////////////////////////////////////////////
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 5,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

/////////////////////////////////////////////////////////////////////////////////////
  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBhb_xtk3doA9uN4d8gzB0o99h0_6R1fE0',
      PointLatLng(customerDestenation.latitude, customerDestenation.longitude),
      PointLatLng(driverDestnation.latitude, driverDestnation.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    var x = Provider.of<UserIformations>(context, listen: false).id;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('order').doc(x).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: (CircularProgressIndicator()));
        }

        customerDestenation = Position(
            latitude: double.parse(snapshot.data['latPosition']),
            longitude: double.parse(snapshot.data['longPosition']));

        MarkerId markerId = MarkerId('customer');
        Marker marker = Marker(
          position: LatLng(
              customerDestenation.latitude, customerDestenation.longitude),
          draggable: true,
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarkerWithHue(90),
        );
        markers[markerId] = marker;
        return Scaffold(
            appBar: AppBar(title: Text('Get Location')),
            body: Stack(
              children: [
                GoogleMap(
                  onTap: _handleTap,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(snapshot.data['latPosition']),
                          double.parse(snapshot.data['longPosition'])),
                      zoom: 15),
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(markers.values),
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        driverDestnation = pos[index];
                        _addMarker(
                            LatLng(driverDestnation.latitude,
                                driverDestnation.longitude),
                            'driver',
                            BitmapDescriptor.defaultMarkerWithHue(90));
                        print(index);
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: 80,
                        height: 80,
                        color: Colors.black54,
                        child: Text('order+ $index'),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
