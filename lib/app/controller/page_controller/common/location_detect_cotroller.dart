import 'dart:async';

import 'package:da_sdoninja/app/extension/geocoding_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationDetectController extends GetxController {
  double latitude = 0;
  double longitude = 0;
  String address = 'Getting Address..';
  late StreamSubscription<Position> streamSubscription;
    TextEditingController addressTextFieldController=TextEditingController();
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 30,
  );

  @override
  void onInit() async {
    super.onInit();
    requestPermission();
  }

  @override
  void onClose() {
    //streamSubscription.cancel();
    super.onClose();
  }

  requestPermission() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  getLocation() {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    streamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).asBroadcastStream().listen((Position position) async {
      latitude = position.latitude;
      longitude = position.longitude;
      address = await GeocodingOnPosition.getAddressPostiton(position);
      addressTextFieldController.text = address;
    });
  }

  Future<void> getCurrentPosition() async {
    if (addressTextFieldController.text.isEmpty) {
      Position? position = await Geolocator.getLastKnownPosition();
      latitude = position!.latitude;
      longitude = position.longitude;
      address = await GeocodingOnPosition.getAddressPostiton(position);
      addressTextFieldController.text = address;
    }
  }
}
