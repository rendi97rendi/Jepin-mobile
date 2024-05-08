import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pontianak_smartcity/common/MyHelper.dart';
import 'package:pontianak_smartcity/common/MyString.dart';

class MyGoogleMap extends StatefulWidget {
  final String name;
  final double? lat, lon;
  const MyGoogleMap({Key? key, required this.name, this.lat, this.lon})
      : super(key: key);

  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  //google map
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    _addMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(this.widget.name),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              mapType: _currentMapType,
              myLocationEnabled: true,
              markers: markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  this.widget.lat ?? 0.0,
                  this.widget.lon ?? 0.0,
                ),
                zoom: 17.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: new FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  child: new Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //google map
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
      // print("rangga" + _currentMapType.toString());
    });
  }

  void _addMarker() {
    InfoWindow infoWindow = InfoWindow(
        title: MyString.location +
            " : " +
            MyHelper.returnToString(this.widget.name));

    Marker marker = Marker(
      markerId: MarkerId(markers.length.toString()),
      infoWindow: infoWindow,
      position: LatLng(
        this.widget.lat ?? 0.0,
        this.widget.lon ?? 0.0,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markers.add(marker);
    });
  }
}
