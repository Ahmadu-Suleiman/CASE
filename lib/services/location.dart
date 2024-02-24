// ignore_for_file: use_build_context_synchronously

import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future<GeoPoint> getCurrentLocation(BuildContext context) async {
    Position? currentPosition;
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return const GeoPoint(-1, -1);
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(currentPosition.latitude, currentPosition.longitude);
  }

  static Future<String> getLocationAddressString(GeoPoint? geoPoint,
      {BuildContext? context}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(geoPoint!.latitude, geoPoint.longitude);
    Placemark place = placemarks[0];
    List<String> location = [
      place.street,
      place.subThoroughfare,
      place.thoroughfare,
      place.thoroughfare,
      place.locality,
      place.administrativeArea,
      place.subAdministrativeArea,
      place.subAdministrativeArea,
      place.country
    ].nonNulls.where((element) => element.isNotEmpty).toSet().toList();
    return location.join(',');
  }

  static Future<Placemark> getLocationAddress(GeoPoint geoPoint,
      {BuildContext? context}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
    return placemarks[0];
  }
}
