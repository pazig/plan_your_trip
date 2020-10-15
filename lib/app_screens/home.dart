import 'package:flutter/material.dart';
import 'package:planyourtrip/app_screens/trip_add_view.dart';
import 'package:planyourtrip/app_screens/places_view.dart';
import 'package:planyourtrip/models/trip.dart';
import 'package:planyourtrip/utils/photo_from_google_maps.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:planyourtrip/utils/database_helper.dart';

//Main screen
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper(); //database instance
  List<Trip> trips; //list of trtips
  int tripCount = 0;
  int placeCount = 0;

  @override
  Widget build(BuildContext context) {
    //crete trip list, if it doesn't exists
    if (trips == null) {
      trips = List<Trip>();
      _updateTripView();
    }
    //Main screen
    return Scaffold(
        appBar: AppBar(
          title: Text("My Trips", style: TextStyle(color: Colors.white)),
        ),
        body: getTripsListView(), //view with list of trips
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            // when floating add button is pressed
            // move to other screen
            // where user can add new trip
            onPressed: () async {
              final Trip addedTrip = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTripView(),
                  ));
              if (addedTrip != null) {
                // save trip got from other screen
                addedTrip.id = tripCount;
                tripCount++;
                int result = await databaseHelper.insertTrip(addedTrip);
                trips.add(addedTrip);
              }
              //refresh screen
              setState(() {});
            },
            child: Icon(
              Icons.add,
            )));
  }

  // Generate view with list trips
  Widget getTripsListView() {
    if (trips.length > 0) {
      var listView = ListView.builder(
          itemCount: trips.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              elevation: 1.0,
              child: ListTile(
                leading: getPlacePhoto(),
                //get image icon
                title: Text(trips[index].destination),
                subtitle: Text(
                    trips[index].startDate.toString().substring(0, 10) +
                        " - " +
                        trips[index].endDate.toString().substring(0, 10)),
                // delete icon with handling
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _delete(context, trips[index]);
                  },
                ),

                //on tap on card move to other route with place view of tapped trip
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacesView(
                          trip: trips[index],
                          placeCount: placeCount,
                          databaseHelper: databaseHelper),
                    ),
                  );
                },
              ),
            );
          });
      return listView;
    } else //if there is any trip added yet, display message to user
      return Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Please add any trip using floating button below",
              style: TextStyle(fontSize: 20.0, color: Colors.grey)));
  }

  // Handle the Trip delete logic, cover DataBase use and List update
  void _delete(BuildContext context, Trip trip) async {
    int resultPlace = await databaseHelper.deletePlace(trip.id);
    int resultTrip = await databaseHelper.deleteTrip(trip.id);
    trips.remove(trip);
    _showSnackBar(context, 'Trip Deleted Successfully');
    _updateTripView();
  }

  // Display SnackBar with message
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Get data from database, update local variables depended at db info, refresh screen
  void _updateTripView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    this.tripCount = await databaseHelper.getTripCount() + 1;
    this.placeCount = await databaseHelper.getPlaceCount() + 1;
    dbFuture.then((database) {
      Future<List<Trip>> tripListFuture = databaseHelper.getTripList();
      tripListFuture.then((trips) {
        setState(() {
          this.trips = trips;
        });
      });
    });
  }
}
