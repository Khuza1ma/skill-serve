import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../local/user_provider.dart';

/// DIO interceptor to add the authentication token
InterceptorsWrapper addAuthToken() => InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        if (UserProvider.authToken != null) {
          options.headers.addAll(<String, dynamic>{
            'Authorization': 'Bearer ${UserProvider.authToken}',
          });
        }
        handler.next(options);
      },
    );

/// API service of the application. To use Get, POST, PUT and PATCH rest methods
class APIService {
  static final Dio _dio = Dio();

  // static const String _baseUrl = 'http://13.60.208.221:5000/api/';

  /// Initialize the API service
  static void initialize() {
    _dio.interceptors.add(addAuthToken());

    if (kDebugMode) {
      //Add interceptor for console logs
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ));
    }
  }

  /// GET rest API call
  /// Used to get data from backend
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<T>?> get<T>({
    required String path,
    Map<String, dynamic>? params,
    bool encrypt = true,
    String? forcedBaseUrl,
    Options? options,
  }) async =>
      _dio.get<T>(
        '/api/$path',
        queryParameters: params,
        options: options ??
            Options(headers: <String, dynamic>{
              'encrypt': encrypt,
            }),
      );

  /// POST rest API call
  /// Used to send any data to server and get a response
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<Map<String, dynamic>?>?> post({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool encrypt = true,
    String? forcedBaseUrl,
  }) async =>
      _dio.post<Map<String, dynamic>?>(
        '/api/$path',
        data: data,
        queryParameters: params,
        options: Options(headers: <String, dynamic>{
          'encrypt': encrypt,
        }),
      );

  /// PUT rest API call
  /// Usually used to create new record
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<Map<String, dynamic>?>?> put({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool encrypt = true,
    String? forcedBaseUrl,
  }) async =>
      _dio.put<Map<String, dynamic>?>(
        '/api/$path',
        data: data,
        queryParameters: params,
        options: Options(headers: <String, dynamic>{
          'encrypt': encrypt,
        }),
      );

  /// PATCH rest API call
  /// Usually used to update any record
  ///
  /// Use [forcedBaseUrl] when want to use specific baseurl other
  /// than configured
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<Map<String, dynamic>?>?> patch({
    required String path,
    FormData? data,
    Map<String, dynamic>? params,
    bool encrypt = true,
    String? forcedBaseUrl,
  }) async =>
      _dio.patch<Map<String, dynamic>?>(
        '/api/$path',
        data: data,
        queryParameters: params,
        options: Options(headers: <String, dynamic>{
          'encrypt': encrypt,
        }),
      );

  /// DELETE rest API call
  /// Used to delete a resource from the server
  ///
  /// Use [forcedBaseUrl] when you want to use a specific base URL other
  /// than the configured one
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  static Future<Response<Map<String, dynamic>?>?> delete({
    required String path,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
  }) async =>
      _dio.delete<Map<String, dynamic>?>(
        '/api/$path',
        queryParameters: params,
      );

  /// Upload file to the server. You will get the URL in the response if the
  /// [file] was uploaded successfully. Else you will get null in response.
  ///
  // static Future<String?> uploadFile({
  //   required File file,
  //   required String folder,
  // }) async {
  //   final Response<Map<String, dynamic>?>? response = await APIService.post(
  //     path: '/user/upload/$folder/images',
  //     data: FormData.fromMap(
  //       <String, dynamic>{
  //         'images': MultipartFile.fromBytes(
  //           List<int>.from(await file.readAsBytes()),
  //           contentType:
  //               http_parser.MediaType('image', path.extension(file.path)),
  //           filename: file.path,
  //         ),
  //       },
  //     ),
  //     encrypt: false,
  //   );
  //
  //   if (response?.statusCode != 200) {
  //     return null;
  //   }
  //
  //   final Map<String, dynamic>? data = response?.data;
  //
  //   if (data?['code'] == 'FILE_UPLOADED') {
  //     logE(data?['file']);
  //     return data?['file'] as String?;
  //   } else {
  //     return null;
  //   }
  // }
}
