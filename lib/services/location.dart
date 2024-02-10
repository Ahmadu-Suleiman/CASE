// ignore_for_file: use_build_context_synchronously

import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static late BuildContext _storedContext;

  static Future<bool> _handleLocationPermission(BuildContext context) async {
    _storedContext = context;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(_storedContext).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utility.showSnackBar(_storedContext, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Utility.showSnackBar(_storedContext,
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  static Future<Position?> _getCurrentPosition(BuildContext context) async {
    Position? currentPosition;
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return currentPosition;
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<List<String>> getLocation(BuildContext context) async {
    Position? position = await _getCurrentPosition(context);
    if (position != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      List<String> location = [
        place.street,
        place.thoroughfare,
        place.locality,
        place.administrativeArea,
        place.country
      ].nonNulls.toList();
      return location;
    }
    return <String>[];
  }
}
