import 'package:get_storage/get_storage.dart';
import 'dart:async';

part 'store_helper.dart';
part 'storage_keys.dart';

/// StoreObject is a helper class to store and retrieve data from local storage
class StoreObject<T> {
  /// Constructor for the StoreObject
  StoreObject({
    required this.key,
    this.value,
    T? initialValue,
  }) {
    if (call() == null && initialValue != null) {
      call(initialValue);
    }
  }

  /// Key for the local storage
  final String key;

  /// Value of the local storage key
  T? value;

  /// Get or set the value
  T? call([T? v]) {
    if (v != null) {
      _Store.write(key, v);
      value = v;
    }

    return value ??= _Store.read<T?>(key);
  }

  /// Erase the value from local storage
  void erase() {
    unawaited(_Store.remove(key));
    value = null;
  }

  @override
  String toString() => value.toString();
}

/// Local storage keys with built in helpers
class LocalStore {
  /// auth token
  static final StoreObject<String> authToken =
      StoreObject<String>(key: StorageKeys.authTokenKey);

  /// logged in user
  static final StoreObject<String> user =
      StoreObject<String>(key: StorageKeys.userDataKey);

  /// user id
  static final StoreObject<int> userId =
      StoreObject<int>(key: StorageKeys.userId);

  /// Erase all local stored data
  static Future<void> erase() async {
    await _Store.erase();
  }
}
