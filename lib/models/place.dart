import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';


enum placeEnum { hotel, food, attraction }

class Place {
  int _placeID;
  int _tripID;
  String _name = "";
  DateTime _date;
  String _address;
  placeEnum _type;
  LatLng _location;
  String _placeGoogleId;
  String _icon;

  Place(this._placeID, this._tripID, this._name, this._date, this._address, this._location, this._placeGoogleId,
      this._type,);


  String get icon => _icon;

  set icon(String value) {
    _icon = value;
  }

  String get placeGoogleId => _placeGoogleId;

  set placeGoogleId(String value) {
    _placeGoogleId = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  int get placeID => _placeID;

  set placeID(int value) {
    _placeID = value;
  }

  int get tripID => _tripID;

  set tripID(int value) {
    _tripID = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get adress => _address;

  set adress(String value) {
    _address = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  //Convert a Place object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (placeID != null) {
      map['placeID'] = placeID;
    }
    map['place_trip_id'] = _tripID;
    map['place_name'] = _name;
    map['place_date'] = _date.toIso8601String();
    map['place_address'] = _address;
    map['place_latitude'] = this._location.toJson()[0] ;
    map['place_longitude'] = this._location.toJson()[1].toString();
    map['place_address'] = _address;
    map['place_google_id'] = this._placeGoogleId;
    map['place_icon'] = this._icon;
    return map;
  }

  //Extract a Place object from a Map object
  Place.fromMapObject(Map<String, dynamic> map) {
    this._placeID = map['placeID'];
    this._tripID = map['place_trip_id'];
    this._name = map['place_name'];
    this._date = DateTime.parse(map['place_date']);
    this._address = map['place_address'];
    double latitude = map['place_latitude'];
    double longitude = map['place_longitude'];
    debugPrint("$latitude , $longitude");
    this._location = new LatLng(latitude, longitude);
    this._placeGoogleId = map['place_google_id'];
    this._icon = map['place_icon'];
    if(map['place_type'].toString() == placeEnum.attraction.toString()) this._type = placeEnum.attraction;
    else
    if(map['placeType'].toString() == placeEnum.food.toString()) this._type = placeEnum.food;
    else
      this._type = placeEnum.hotel;

    this._type = map['placeType'];
  }

  placeEnum get type => _type;

  set type(placeEnum value) {
    _type = value;
  }

  LatLng get location => _location;

  set location(LatLng value) {
    _location = value;
  }
}
