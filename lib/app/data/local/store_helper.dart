part of 'local_store.dart';

class _Store {
  static final GetStorage _ = GetStorage();

  static T? read<T>(String key) => _.read<T?>(key);

  static Future<void> write(String key, dynamic value) async =>
      _.write(key, value);

  // Erase a key
  static Future<void> remove(String key) async => _.remove(key);

  static Future<void> erase() => _.erase();
}
