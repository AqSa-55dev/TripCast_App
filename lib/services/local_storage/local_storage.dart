
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _storage = GetStorage();

  static dynamic getData({required String key}) {
    return _storage.read(key);
  }

  static Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    await _storage.write(key, value);
  }

  static Future<void> removeData({required String key}) async {
    await _storage.remove(key);
  }
}
