import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// should use placeId or name to use in Google Places API
// and return an Image of this place
// For now it only returns plain image icon
// It requires more efford in coding
// and better understanding of Google Places API and Flutter Json fetch
Widget getPlacePhoto(){
  //TODO
  return Icon(Icons.image);
}

// Get image url from Google Places API using Place ID
Future<String> getPlacePhotoFromId(String placeId) async {

  Photo photo = await fetchPhoto(placeId);

  String photoReference = photo.photoReference;
  debugPrint('$photoReference');
  //place Google API Key here
  return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=$photoReference&key=AAAAAAAAAAAAAAAAAAA";

}

// Correspond witch Json to get a Photo instance
Future<Photo> fetchPhoto(String placeId) async {
//place google API Key below
  final response = await http.get('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=AAAAAAAAAAAAAAAAAAAAAAA');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Photo.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load photo');
  }
}

// Represents Google Place Photo
// For now it only contains Google Photo References
class Photo{
  final String photoReference;
  Photo({this.photoReference});

  //TODO: still doesn't working...
  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
        photoReference: json['photo_reference']
    );
  }
}