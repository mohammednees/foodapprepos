import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:geolocator/geolocator.dart';

class Poly extends StatefulWidget {
  @override
  _PolyState createState() => _PolyState();
}

class _PolyState extends State<Poly> {
  GoogleMapController mapController;
  double _originLatitude = 31.906707, _originLongitude = 35.213371;
  double _destLatitude = 31.925395, _destLongitude = 35.213917;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyBhb_xtk3doA9uN4d8gzB0o99h0_6R1fE0';

  Future<Position> getLcationGeo() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  _handleTap(LatLng tappedPoint) {
    markers = {};
    _addMarker(tappedPoint, 'CustomerDistination',
        BitmapDescriptor.defaultMarkerWithHue(90));
  }

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: _handleTap,
            initialCameraPosition: CameraPosition(
                target: LatLng(_originLatitude, _originLongitude), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                onPressed: () {
                  Future pos = getLcationGeo().then((value) {
                    _addMarker(LatLng(value.latitude, value.longitude), 'home',
                        BitmapDescriptor.defaultMarkerWithHue(90));
                    print(value.toString());
                  });
                },
                child: Text('Get location'),
              )),
        ],
      )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    setState(() {
      MarkerId markerId = MarkerId(id);
      Marker marker = Marker(
        position: position,
        draggable: true,
        markerId: markerId,
        icon: descriptor,
      );
      markers[markerId] = marker;
      _destLatitude = position.latitude;
      _destLongitude = position.longitude;
      polylines.clear();
      polylineCoordinates.clear();
      _getPolyline();
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBhb_xtk3doA9uN4d8gzB0o99h0_6R1fE0',
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
/*  var any = Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      await Firestore.instance
          .collection('order')
          .document(
              Provider.of<SelectedSreen>(context, listen: false).userIdName)
          .setData({
        'username': userName,
        'creatAt': createAt,
        'total': total,
        'meallist': xxx,
        'phoneNumber': phone,
        'latPosition': value.latitude,
        'longPosition': value.longitude,
      });
    }); */
