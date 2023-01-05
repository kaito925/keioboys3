import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Keioboys/consts.dart';

Future getDistance(GeoPoint userLocation) async {
  try {
    Position position;
    double location;
    if (userLocation.latitude != null) {
      if (android || ios) {
        position = await Geolocator.getLastKnownPosition();
      } else if (web) {
        position = await Geolocator.getCurrentPosition();
      }
      location = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        position.latitude,
        position.longitude,
      );
    }
    return location.toInt();
  } catch (error) {
    print('error: $error');
  }
}
