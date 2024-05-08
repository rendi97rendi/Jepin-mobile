import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pontianak_smartcity/common/MyConstanta.dart';

class MapWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  MapWidget({
    required this.markers,
    required this.onMapCreated,
  });

  static CameraPosition cameraPosition = CameraPosition(
    target:
        LatLng(MyConstanta.pontianakLatitude, MyConstanta.pontianakLongitude),
    zoom: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      compassEnabled: false,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      onMapCreated: onMapCreated,
      markers: markers,
    );
  }
}
