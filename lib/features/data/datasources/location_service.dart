import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Stream<LatLng> simulateLocationStream({LatLng? initialPosition}) async* {
    LatLng position =
        initialPosition ?? const LatLng(37.42796133580664, -122.085749655962);
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      position =
          LatLng(position.latitude + 0.0001, position.longitude + 0.0001);
      yield position;
    }
  }

  Future<Stream<LatLng>> getLiveLocationStream() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((position) => LatLng(position.latitude, position.longitude));
  }
}
