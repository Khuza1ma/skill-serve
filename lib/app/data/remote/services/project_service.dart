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
          return Project.fromJson(data);
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return null;
    }
  }

  /// Fetch projects with pagination
  static Future<Map<String, dynamic>?> fetchProjects({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: 'projects',
        params: {
          'page': page,
          'limit': limit,
        },
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? responseData = response?.data;
        if (responseData != null && responseData.containsKey('data')) {
          final Map<String, dynamic> data = responseData['data'];
          // Check if projects and pagination exist in the response
          if (data.containsKey('projects') && data.containsKey('pagination')) {
            final projectsList = data['projects'];
            final pagination = data['pagination'];

            if (projectsList is List && pagination is Map<String, dynamic>) {
              return {
                'projects': projectsList
                    .map((project) => Project.fromJson(project))
                    .toList(),
                'pagination': pagination,
              };
            } else {
              logE(
                  'Invalid data structure: projects is not a List or pagination is not a Map');
              return null;
            }
          } else {
            logE('Missing required fields in response: projects or pagination');
            return null;
          }
        } else {
          logE('Missing data field in response');
          return null;
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return null;
    } catch (e, st) {
      logE('Unexpected error in fetchProjects: $e\n$st');
      return null;
    }
  }

  /// Update an existing project
  static Future<Project?> updateProject(
      String projectId, Project project) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.put(
        data: project.toJson(),
        path: 'projects/$projectId',
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? data = response?.data?['data'];
        if (data != null) {
          return Project.fromJson(data);
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return null;
    }
  }

  /// Delete a project
  static Future<bool> deleteProject(String projectId) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.delete(
        path: 'projects/$projectId',
      );

      if (response?.isOk ?? false) {
        return true;
      }
      return false;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return false;
    }
  }
}
