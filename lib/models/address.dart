import 'package:geocoding/geocoding.dart';

class Address {
  String? street;
  String? subThoroughfare;
  String? thoroughfare;
  String? locality;
  String? administrativeArea;
  String? subAdministrativeArea;
  String? country;

  Address({
    required this.street,
    required this.subThoroughfare,
    required this.thoroughfare,
    required this.locality,
    required this.administrativeArea,
    required this.subAdministrativeArea,
    required this.country,
  });

  Address.fromPlacemark(Placemark placemark) {
    street = placemark.street;
    subThoroughfare = placemark.subThoroughfare;
    thoroughfare = placemark.thoroughfare;
    locality = placemark.locality;
    administrativeArea = placemark.administrativeArea;
    subAdministrativeArea = placemark.subAdministrativeArea;
    country = placemark.country;
  }
}
