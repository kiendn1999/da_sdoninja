import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeocodingOnPosition  {
  static Future<String>  getAddressPostiton(Position position) async {
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    return "${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
  }

    static Future<String>  getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemark[0];
    return "${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
  }
}
