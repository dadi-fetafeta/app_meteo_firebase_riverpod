import 'package:geocoding/geocoding.dart';

class GeocodingService {
  Future<String> getCityName(double lat, double lon) async {
    final placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? "Ville inconnue";
    }
    return "Ville inconnue";
  }
}
