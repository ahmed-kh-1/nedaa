import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> _checkPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String?>getLocationLink() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      return null;
    }

    try {
      final LocationData locationData = await _location.getLocation();
      final lat = locationData.latitude;
      final long = locationData.longitude;
      return 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
  
}
