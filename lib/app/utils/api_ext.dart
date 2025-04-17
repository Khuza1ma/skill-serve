import 'package:dio/dio.dart';

/// Extension for Dio Response
extension DioResponseExt on Response<dynamic> {
  /// Check if the response is successful
  bool get isOk {
    if (statusCode != null) {
      return statusCode! >= 200 && statusCode! < 300;
    }

    return false;
  }
}
