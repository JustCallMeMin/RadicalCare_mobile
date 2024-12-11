import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Kiểm tra và yêu cầu quyền truy cập GPS
  static Future<bool> checkAndRequestPermission() async {
    try {
      // Kiểm tra GPS service có bật không
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("[LocationService] GPS service is disabled.");
        return false; // GPS chưa được bật
      }

      // Kiểm tra quyền hiện tại
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print("[LocationService] Requesting location permission...");
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          print("[LocationService] Location permissions are denied.");
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("[LocationService] Location permissions are permanently denied.");
        return false;
      }

      print("[LocationService] Permission granted.");
      return true;
    } catch (e) {
      print("[LocationService] Error during permission check: $e");
      return false;
    }
  }

  /// Lấy vị trí hiện tại với cấu hình mới
  static Future<Position?> getCurrentLocation() async {
    try {
      print("[LocationService] Fetching current location...");
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // Sử dụng LocationSettings
        ),
      );
      print("[LocationService] Current location: lat=${position.latitude}, lng=${position.longitude}");
      return position;
    } catch (e) {
      print("[LocationService] Error getting location: $e");
      return null;
    }
  }
}
