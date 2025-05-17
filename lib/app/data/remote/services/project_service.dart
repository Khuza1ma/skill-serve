import 'package:dio/dio.dart';
import 'package:skill_serve/app/utils/api_ext.dart';

import '../../config/error_handling.dart';
import '../../config/logger.dart';
import '../../models/project_model.dart';
import '../api_service/init_api_service.dart';

class ProjectService {
  /// Create a new project
  static Future<Project?> createProject(Project project) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        data: project.toJson(),
        path: 'projects',
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? data = response?.data?['data'];
        if (data != null) {
          logI('Project created: $data');
          return Project.fromJson(data);
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return null;
    }
  }
}
