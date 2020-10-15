import 'package:planyourtrip/models/place.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:planyourtrip/models/trip.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance(); //named constructor to create instance of DatabaseHelper

  //trip
  String tripTable = 'trip_table';
  String tripId = 'id';
  String tripDestination = 'destination';
  String tripStartDate = 'startDate';
  String tripEndDate = 'endDate';

  //place
  String placeTable = 'place_table';
  String placeTripId = 'place_trip_id';
  String placeId = 'placeID';
  String placeName = 'place_name';
  String placeDate = 'place_date';
  String placeAddress = 'place_address';
  String placeLatitude = 'place_latitude';
  String placeLongitude = 'place_longitude';
  String placeType = 'place_type';
  String placeGoogleId = 'place_google_id';
  String placeIcon = 'place_icon';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); //this is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //get directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'trip.db';

    //open/create database at given path
    var tripDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return tripDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    //trip
    await db.execute(
        'CREATE TABLE $tripTable($tripId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$tripDestination TEXT, $tripStartDate TEXT,  $tripEndDate TEXT)');

    //place
    await db.execute(
        'CREATE TABLE $placeTable($placeId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$placeTripId INTEGER, $placeName TEXT, '
        '$placeDate TEXT, $placeAddress TEXT, $placeLatitude DOUBLE, '
        '$placeLongitude DOUBLE, $placeGoogleId TEXT, $placeIcon TEXT, $placeType INTEGER)');
  }

  //Fetch, get whole Trip Table
  Future<List<Map<String, dynamic>>> getTripMapList() async {
    Database db = await this.database;

    var result = await db.query(tripTable);
    return result;
  }

  //Insert Trip
  Future<int> insertTrip(Trip trip) async {
    Database db = await this.database;
    var result = await db.insert(tripTable, trip.toMap());
    return result;
  }

  //Update Trip
  Future<int> updateTrip(Trip trip) async {
    Database db = await this.database;
    var result = await db.update(tripTable, trip.toMap(),
        where: '$tripId = ?', whereArgs: [trip.id]);
    return result;
  }

  //Delete Trip
  Future<int> deleteTrip(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $tripTable WHERE $tripId = $id');
    return result;
  }

  //Get number of Trip elements in Database
  Future<int> getTripCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $tripTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Place
  //Fetch, get whole Place Table
  Future<List<Map<String, dynamic>>> getPlaceMapList() async {
    Database db = await this.database;

    var result = await db.query(placeTable);
    return result;
  }

  //Insert Place
  Future<int> insertPlace(Place place) async {
    Database db = await this.database;
    var result = await db.insert(placeTable, place.toMap());
    return result;
  }

  //Update Place
  Future<int> updatePlace(Place place) async {
    Database db = await this.database;
    var result = await db.update(placeTable, place.toMap(),
        where: '$placeId = ?', whereArgs: [place.placeID]);
    return result;
  }

  //Delete one Place
  Future<int> deletePlace(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $placeTable WHERE $placeId = $id');
    return result;
  }

  //Delete all Places from Trip
  Future<int> deleteAllPlace(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $placeTable WHERE $tripId = $id');
    return result;
  }

  //Get number of Place elements in Database
  Future<int> getPlaceCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $placeTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get and convert to Trip List
  Future<List<Trip>> getTripList() async {
    var tripMapList = await getTripMapList(); // Get Mp list from db

    int count =
        tripMapList.length; //count the number of trip entries in db table

    List<Trip> tripList = List<Trip>();

    for (int i = 0; i < count; i++) {
      tripList.add(Trip.fromMapObject(tripMapList[i]));
      var placeMapList = await getPlaceMapList(); // Get Mp list from db
      int countPlaces = placeMapList.length;
      for (int j = 0; j < countPlaces; j++) {
        Place currentPlace = Place.fromMapObject(placeMapList[j]);
        if (currentPlace.tripID == tripList[i].id) {
          if (tripList[i].places == null)
            tripList[i].places = new List<Place>();
          tripList[i].countPlaces++;
          tripList[i].places.add(currentPlace);
        }
      }
    }

    return tripList;
  }
}
