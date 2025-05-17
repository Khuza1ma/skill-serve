import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/utils/api_ext.dart';
import '../../../ui/components/app_snackbar.dart';
import '../api_service/init_api_service.dart';
import '../../config/error_handling.dart';
import '../../local/user_provider.dart';
import '../../models/user_entity.dart';
import 'package:dio/dio.dart';

/// APIs related to user
class UserService {
  /// Login using username and password
  static Future<User?> login({
    required String username,
    required String password,
  }) async {
    User? user;
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'auth/login/',
        data: {
          'usernameOrEmail': username,
          'password': password,
        },
      );

      if ((response?.isOk ?? false)) {
        final Map<String, dynamic>? loginData = response?.data?['data'];
        if ((loginData != null)) {
          logI('Login data: $loginData');
          user = User.fromMap(
            loginData,
          );
          UserProvider.onLogin(
            user: user,
            userAuthToken: loginData['token'],
          );
        }
      }
    } on DioException catch (e, st) {
      letMeHandleAllErrors(
        e,
        st,
        showSnackBar: false,
      );
    }
    return user;
  }

  /// Register a new user
  static Future<bool> signUp({
    required String username,
    required String password,
    required String email,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'auth/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'role': 'volunteer',
        },
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? loginData = response?.data?['data'];
        if ((loginData != null)) {
          logI('Login data: $loginData');
          final user = User.fromMap(
            loginData,
          );
          UserProvider.onLogin(
            user: user,
            userAuthToken: loginData['token'],
          );
        }
        return true;
      } else {
        return false;
      }
    } on DioException catch (e, st) {
      letMeHandleAllErrors(
        e,
        st,
        showSnackBar: false,
      );
      appSnackbar(
        title: 'Registration failed',
        message: '${e.response?.data['message']}',
        snackBarState: SnackBarState.DANGER,
      );
      return false;
    }
  }

  /// Logout a user
  static Future<bool> logout() async {
    try {
      final response = await APIService.post(
        path: 'auth/logout/',
        data: {},
      );
      if (response?.statusCode == 200) {
        UserProvider.onLogout();
        return true;
      }
      return false;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st, showSnackBar: false);
      appSnackbar(
        title: 'Logout failed',
        message: '${e.response?.data['message']}',
        snackBarState: SnackBarState.DANGER,
      );
      return false;
    }
  }

}
