import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition();

  return position;
}

Future<String> getCurrentAddress() async {
  Position position = await determinePosition();

  return getAddress(position.latitude, position.longitude);

}

Future<String> getAddress(latitude, longitude) async {
  List<Placemark> newPlace = await placemarkFromCoordinates(latitude, longitude);

  // this is all you need
  Placemark? placeMark  = newPlace[0];
  String? street = placeMark.street;
  String? sublocality = placeMark.subLocality;
  String? locality = placeMark.locality;
  String? administrativeArea = placeMark.administrativeArea;
  String? postalCode = placeMark.postalCode;
  String? country = placeMark.country;
  String? address = "${street}, ${sublocality}, ${locality}, ${administrativeArea}, ${postalCode}, ${country}";

  return address;


}

