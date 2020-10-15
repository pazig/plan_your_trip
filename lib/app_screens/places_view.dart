import "package:flutter/material.dart";
import 'package:planyourtrip/app_screens/home.dart';
import 'package:planyourtrip/app_screens/location_map.dart';
import 'package:planyourtrip/models/place.dart';
import 'package:planyourtrip/models/trip.dart';
import 'package:place_picker/place_picker.dart';
import 'package:planyourtrip/utils/database_helper.dart';
import 'package:planyourtrip/utils/photo_from_google_maps.dart';

class PlacesView extends StatefulWidget {
  // In the constructor, require a Trip.
  Trip trip;
  int placeCount;
  final DatabaseHelper databaseHelper;

  PlacesView(
      {Key key,
      @required this.trip,
      @required this.placeCount,
      @required this.databaseHelper})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlacesViewState();
  }
}

class _PlacesViewState extends State<PlacesView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.trip.destination,
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.lightGreen,
        ),
        body: getPlacesListView(),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            // when floating add button is pressed
            // move to other screen
            // where user can add new trip
            onPressed: () {
              showPlacePicker(context);
            },
            child: Icon(
              Icons.add,
            )));
  }

  // Generate view with list Places
  Widget getPlacesListView() {
    if (widget.trip.places != null && widget.trip.places.length > 0) {
      return ListView.builder(
        itemCount: widget.trip.places.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 1.0,
            child: ListTile(
                leading:
                getPlacePhoto(),
                title: Text(widget.trip.places[index].name),
                subtitle: Text(widget.trip.places[index].adress),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _delete(context, widget.trip.places[index]);
                  },
                ),
                onTap: () {
                  _navigate(context, widget.trip.places[index]);
                }),
          );
        },
      );
    } else
      return Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Please add any place using floating button below",
              style: TextStyle(fontSize: 20.0, color: Colors.grey)));
  }

  //open location map widget
  void _navigate(BuildContext context, Place place) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationMap(location: place.location),
        ));
  }

  // show map widget used to pick up a place you want to visit
  void showPlacePicker(BuildContext context) async {
    LatLng customLocation;
    if(widget.trip.places == null)
      customLocation = LatLng(50.1021742, 18.5462847);
    else
      customLocation = widget.trip.places.last.location;

//put your Google API_KEY below
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa",
              displayLocation: customLocation,
            )));

    widget.placeCount++;

    //  Place(this._placeID, this._tripID, this._name, this._date, this._address, this._type);
    Place place = Place(
        widget.placeCount,
        widget.trip.id,
        result.name,
        DateTime.now(),
        result.formattedAddress,
        result.latLng,
        result.placeId,
        placeEnum.attraction);

    if (widget.trip.places == null) {
      widget.trip.places = new List<Place>();
    }
    // Handle the result and refresh screen
    widget.trip.places.add(place);

    //save in DB
    await widget.databaseHelper.insertPlace(place);
    setState(() {});
  }

  // delete given Place from collection and database
  void _delete(BuildContext context, Place place) async {
    int resultPlace = await widget.databaseHelper.deletePlace(place.placeID);
    widget.trip.places.remove(place);
    _showSnackBar(context, 'Place Deleted Successfully');
    _updatePlaceView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _updatePlaceView() {
    setState(() {});
  }
}
