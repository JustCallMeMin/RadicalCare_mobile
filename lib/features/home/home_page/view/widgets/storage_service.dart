import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _secureStorage = FlutterSecureStorage();

  Future<void> saveFullName(String fullName) async {
    await _secureStorage.write(key: 'fullName', value: fullName);
  }

  Future<String?> getFullName() async {
    return await _secureStorage.read(key: 'fullName');
  }

  Future<void> removeFullName() async {
    await _secureStorage.delete(key: 'fullName');
  }
}

