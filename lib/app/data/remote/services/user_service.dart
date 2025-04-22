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
      final Response<Map<String, dynamic>?>? loginResponse =
          await APIService.post(
        path: 'api/token-auth/',
        data: FormData.fromMap(<String, dynamic>{
          'username': username,
          'password': password,
        }),
      );

      final Response<Map<String, dynamic>?>? userInfoResponse =
          await APIService.get(
        path: 'api/get_info/',
        options: Options(
          headers: <String, dynamic>{
            'Authorization': "Token ${loginResponse?.data?['token']}"
          },
        ),
      );

      if ((loginResponse?.isOk ?? false) && (userInfoResponse?.isOk ?? false)) {
        final Map<String, dynamic>? loginData = loginResponse?.data;
        final Map<String, dynamic>? userData = userInfoResponse?.data;

        if ((loginData?['token'] != null) &&
            (userData?['current_user_id'] != null)) {
          user = User(
            currentUserId: userData?['current_user_id'],
            currentUsername: userData?['current_username'],
            currentUserEmail: userData?['current_user_email'],
          );

          UserProvider.onLogin(
            user,
            loginData?['token'],
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
