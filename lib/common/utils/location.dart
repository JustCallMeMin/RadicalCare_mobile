import 'package:geolocator/geolocator.dart';

Future<bool> checkAndRequestPermission() async {
  // Kiểm tra dịch vụ GPS có bật không
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("GPS service is disabled.");
    return false;
  }

  // Kiểm tra quyền
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permissions are denied.");
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("Location permissions are permanently denied.");
    return false;
  }

  return true;
}

Future<Position?> getCurrentLocation() async {
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (e) {
    print("Error getting location: $e");
    return null;
  }
}
