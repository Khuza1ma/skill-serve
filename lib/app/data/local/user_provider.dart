import '../../routes/app_pages.dart';
import '../models/user_entity.dart';
import '../config/encryption.dart';
import 'local_store.dart';
import 'dart:convert';

/// Helper class for local stored User
class UserProvider {
  static User? _userEntity;
  static String? _authToken;
  static late bool _isLoggedIn;

  /// Get currently logged in user
  static User? get currentUser => _userEntity;

  /// Get auth token of the logged in user
  static String? get authToken => _authToken;

  /// If the user is logged in or not
  static bool get isLoggedIn => _isLoggedIn;

  ///Set [currentUser] and [authToken]
  static void onLogin({
    required User user,
    required String userAuthToken,
  }) {
    _isLoggedIn = true;
    _userEntity = user;
    _authToken = userAuthToken;
    LocalStore.user(
        AppEncryption.encrypt(plainText: jsonEncode(user.toJson())));
    LocalStore.authToken(userAuthToken);
  }

  ///Load [currentUser] and [authToken]
  static void loadUser() {
    final String? userData = LocalStore.user();

    if (userData != null) {
      _isLoggedIn = true;
      _userEntity = User.fromJson(AppEncryption.decrypt(cipherText: userData));
      _authToken = LocalStore.authToken()!;
    } else {
      _isLoggedIn = false;
    }
  }

  ///Remove [currentUser] and [authToken] from local storage
  static void onLogout() {
    _isLoggedIn = false;
    _userEntity = null;
    _authToken = null;
    LocalStore.authToken.erase();
    LocalStore.user.erase();
  }

  /// Get initial route based on user login status
  static String get initialRoute => _isLoggedIn ? Routes.HOME : Routes.LOGIN;
}
