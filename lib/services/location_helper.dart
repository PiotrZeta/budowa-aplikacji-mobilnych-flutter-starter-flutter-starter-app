import 'package:geolocator/geolocator.dart';

class LocationHelper {
  Future<Position> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Usługi lokalizacji są wyłączone. Włącz GPS i spróbuj ponownie.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Brak uprawnień do lokalizacji.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Uprawnienia do lokalizacji są trwale zablokowane. Zmień to w ustawieniach telefonu.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }
}
