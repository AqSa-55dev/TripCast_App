
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _storage = GetStorage();

  // Get data from local storage
  static dynamic getData({required String key}) {
    return _storage.read(key);
  }

  // Save data in local storage
  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    await _storage.write(key, value);
  }

  // Remove data from local storage
  static Future<void> removeData({required String key}) async {
    await _storage.remove(key);
  }
}
