import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Show map centered of certain location
// require LatLng location
class LocationMap extends StatefulWidget {
  final LatLng location;

  LocationMap({Key key, @required this.location}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocationMapState();
  }
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return _googleMap(context);
  }

  //return google Map widget
  Widget _googleMap(BuildContext context) {
    Set<Marker> markers = new Set<Marker>();
    markers
        .add(Marker(markerId: MarkerId("Marker"), position: widget.location));
    return Container(
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: widget.location, zoom: 15.0),
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
//        polylines: poly,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        compassEnabled: true,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
