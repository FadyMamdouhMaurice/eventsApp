import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng parseLocation(String locationString) {
  final latLngRegex = RegExp(r'LatLng\(([\d.-]+), ([\d.-]+)\)');
  final match = latLngRegex.firstMatch(locationString);
  late double latitude, longitude;
  if (match != null && match.groupCount == 2) {
    latitude = double.parse(match.group(1).toString());
    longitude = double.parse(match.group(2).toString());
  }
  return LatLng(latitude, longitude);
}