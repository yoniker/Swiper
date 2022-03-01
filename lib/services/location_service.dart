import 'package:betabeta/services/settings_model.dart';
import 'package:location/location.dart';

enum LocationServiceStatus {
  enabled,
  serviceDisabled,
  userNotGrantedPermission
}

class LocationService {
  static Future<LocationServiceStatus> requestLocationCapability() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LocationServiceStatus.serviceDisabled;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return LocationServiceStatus.userNotGrantedPermission;
      }
    }
    return LocationServiceStatus.enabled;
  }

  static updateLocation(LocationData locationData) {
    if (locationData.longitude == null || locationData.latitude == null) {
      return;
    }
    SettingsData.instance.longitude = locationData.longitude!;
    SettingsData.instance.latitude = locationData.latitude!;
    print(
        'UPDATED LOCATION TO  ${locationData.latitude!},${locationData.longitude!}');
  }

  static void listenLocationChanges() {
    Location location = new Location();
    location.changeSettings(
        accuracy: LocationAccuracy.balanced, interval: 10000000);
    location.onLocationChanged.listen((data) {
      print('location listener triggered update');
      updateLocation(data);
    });
  }

  static Future<LocationData> getLocation() async {
    LocationServiceStatus status =
        await LocationService.requestLocationCapability();
    if (status != LocationServiceStatus.enabled) {
      throw Exception(
          'Location service not enabled when get location was called!');
    }
    Location location = new Location();
    return await location.getLocation();
  }

  static onInit() async {
    var location = await LocationService.getLocation();
    LocationService.updateLocation(location);
    LocationService.listenLocationChanges();
  }
}
