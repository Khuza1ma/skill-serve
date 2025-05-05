import 'package:skill_serve/app/utils/api_ext.dart';
import '../../local/user_provider.dart';
import '../api_service/init_api_service.dart';
import '../../config/error_handling.dart';
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
        data: FormData.fromMap(<String, dynamic>{
          'usernameOrEmail': username,
          'password': password,
        }),
      );

      if ((response?.isOk ?? false)) {
        final Map<String, dynamic>? loginData = response?.data?['data'];
        if ((loginData != null)) {
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
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'api/user/register/',
        data: FormData.fromMap(<String, dynamic>{
          'username': username,
          'password': password,
        }),
      );

      if (response?.isOk ?? false) {
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
      return false;
    }
  }
}
