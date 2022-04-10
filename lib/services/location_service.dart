import 'dart:io';

import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

enum LocationServiceStatus {
  initializing,
  enabled,
  serviceDisabled,
  userTemporaryNotGrantedPermission,
  userPermanentlyNotGrantedPermission
}

class LocationService extends ChangeNotifier {
  LocationService._privateConstructor();

  static final LocationService _instance =
  LocationService._privateConstructor();

  static LocationService get instance => _instance;

  static const Duration minTimeUpdateLocation = Duration(hours: 1);

  DateTime lastUpdateDate = DateTime(1990);

  LocationServiceStatus _status = LocationServiceStatus.initializing;

  Future<LocationServiceStatus> requestUpdateLocationCapability() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return LocationServiceStatus.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return LocationServiceStatus.userTemporaryNotGrantedPermission;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return LocationServiceStatus.userPermanentlyNotGrantedPermission;
    }
     return LocationServiceStatus.enabled;
  }

  Future<LocationServiceStatus> requestLocationCapability() async {
    _status = await requestUpdateLocationCapability();
    return _status;
  }

  LocationServiceStatus get serviceStatus => _status;

  bool needChangeAppSettings(){
    if(LocationService.instance.serviceStatus == LocationServiceStatus.userPermanentlyNotGrantedPermission)
      {return true;}
        if(Platform.isIOS && LocationService.instance.serviceStatus == LocationServiceStatus.userTemporaryNotGrantedPermission)
          {return true;}
        return false;
  }

  updateLocation(Position? locationData) {
    if(locationData==null){return;}
    if (!(DateTime.now().difference(lastUpdateDate) > minTimeUpdateLocation)) {
      print('Too soon to update server');
      return;
    }
    SettingsData.instance.longitude = locationData.longitude;
    SettingsData.instance.latitude = locationData.latitude;
    lastUpdateDate = DateTime.now();
    print(
        'UPDATED LOCATION TO  ${locationData.latitude},${locationData.longitude}');
    notifyListeners();
  }

  void _listenLocationChanges() {
    Geolocator.getPositionStream().listen(
    (data) {
      print('location listener triggered update');
      updateLocation(data);
    });
  }

  Future<Position?> getLocation() async {
    LocationServiceStatus status = await requestLocationCapability();
    if (status != LocationServiceStatus.enabled) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  onInit() async {
    var location = await getLocation();
    if (location != null) {
      updateLocation(location);
    }
    _listenLocationChanges();
  }
}