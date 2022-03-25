import 'package:betabeta/services/settings_model.dart';
import 'package:location/location.dart';

enum LocationServiceStatus {
  enabled,
  serviceDisabled,
  userNotGrantedPermission
}

class LocationService {


  LocationService._privateConstructor();

  static final LocationService _instance = LocationService._privateConstructor();

  static LocationService get instance => _instance;

  static const Duration minTimeUpdateLocation = Duration(hours: 1);

  DateTime lastUpdateDate = DateTime(2000);





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

   updateLocation(LocationData locationData) {

    if(!(DateTime.now().difference(lastUpdateDate)>minTimeUpdateLocation)){
      print('Too soon to update server');
      return;
    }



    if (locationData.longitude == null || locationData.latitude == null) {
      return;
    }
    SettingsData.instance.longitude = locationData.longitude!;
    SettingsData.instance.latitude = locationData.latitude!;
    lastUpdateDate = DateTime.now();
    print(
        'UPDATED LOCATION TO  ${locationData.latitude!},${locationData.longitude!}');
  }

   void listenLocationChanges() {
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

   onInit() async {
    var location = await LocationService.getLocation();
    updateLocation(location);
    listenLocationChanges();
  }
}
