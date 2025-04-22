import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'logger.dart';

/// To handle all the error app wide
void letMeHandleAllErrors(
  Object error,
  StackTrace? trace, {
  bool showSnackBar = true,
}) {
  // logE(trace);
  // logI('ERROR FROM letMeHandleAllErrors\nERROR TYPE : ${error.runtimeType}');
  switch (error.runtimeType) {
    case const (DioException):
      final Response<dynamic>? res = (error as DioException).response;
      logE('Got error : ${res?.statusCode} -> ${res?.statusMessage}');
      if (showSnackBar) {
        Get.snackbar(
          'Oops!',
          'Got error : ${res?.statusCode} -> ${res?.statusMessage}',
        );
      }
      break;
    default:
      if (showSnackBar) {
        Get.snackbar(
          'Oops!',
          'Something went wrong',
        );
      }
      logE(error.toString());
      logE(trace);
      break;
  }
}
