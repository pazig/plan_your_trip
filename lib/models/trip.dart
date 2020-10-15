import 'package:flutter/material.dart';
import 'place.dart';

class Trip {
  int _id;
  String _destination;
  DateTime _startDate;
  DateTime _endDate;
  List<Place> _places;
  int _countPlaces = 0;

  Trip();

  Trip.set(String destination, DateTimeRange timeRange, [int id]){
    this.id = id;
    this.destination = destination;
    this.startDate = timeRange.start;
    this.endDate = timeRange.end;
  }


  int get countPlaces => _countPlaces;

  set countPlaces(int value) {
    _countPlaces = value;
  }

  set id(int value) {
    _id = value;
  }

  int get id => _id;

  set destination(String value) {
    _destination = value;
  }

  String get destination => _destination;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  List<Place> get places => _places;

  set startDate(DateTime value) {
    _startDate = value;
  }

  set endDate(DateTime value) {
    _endDate = value;
  }

  set places(List<Place> value) {
    _places = value;
  }


  //Convert a Trip object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['destination'] = _destination;
    map['startDate'] = _startDate.toIso8601String();
    map['endDate'] = _endDate.toIso8601String();

    return map;
  }

  //Extract Trip object from a Map object
  Trip.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._destination = map['destination'];
    this._startDate =  DateTime.parse(map['startDate']);
    this._endDate = DateTime.parse(map['endDate']);
  }
}
