import 'package:dio/dio.dart';
import 'package:skill_serve/app/utils/api_ext.dart';

import '../../../ui/components/app_snackbar.dart';
import '../../config/error_handling.dart';
import '../../config/logger.dart';
import '../../models/applied_project_model.dart';
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
      letMeHandleAllErrors(e, st, showSnackBar: false);
      return null;
    }
  }

  /// Fetch projects with pagination
  static Future<Map<String, dynamic>?> fetchProjects({
    int? skip,
    int? limit,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: 'projects',
        params: {
          'skip': skip,
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
      letMeHandleAllErrors(e, st, showSnackBar: false);
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
      letMeHandleAllErrors(e, st, showSnackBar: false);
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

  /// Apply for a project
  static Future<bool> applyProject(String projectId) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
        path: 'applications/$projectId',
      );

      if (response?.isOk ?? false) {
        return true;
      }
      return false;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st, showSnackBar: false);
      appSnackbar(
        title: 'Error',
        message: e.response?.data['message'] ?? 'Failed to apply for project',
        snackBarState: SnackBarState.DANGER,
      );
      return false;
    }
  }

  /// Get applied projects for a volunteer
  static Future<Map<String, dynamic>?> getAppliedProjects({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: 'applications/volunteer',
        params: {
          'page': page,
          'limit': limit,
        },
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? responseData = response?.data;
        if (responseData != null && responseData.containsKey('data')) {
          final Map<String, dynamic> data = responseData['data'];
          // Check if applications and pagination exist in the response
          if (data.containsKey('applications') &&
              data.containsKey('pagination')) {
            final applicationsList = data['applications'];
            final pagination = data['pagination'];

            if (applicationsList is List &&
                pagination is Map<String, dynamic>) {
              return {
                'applications': applicationsList
                    .map((application) => AppliedProject.fromJson(application))
                    .toList(),
                'pagination': pagination,
              };
            } else {
              logE(
                  'Invalid data structure: applications is not a List or pagination is not a Map');
              return null;
            }
          } else {
            logE(
                'Missing required fields in response: applications or pagination');
            return null;
          }
        } else {
          logE('Missing data field in response');
          return null;
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st, showSnackBar: false);
      return null;
    } catch (e, st) {
      logE('Unexpected error in getAppliedProjects: $e\n$st');
      return null;
    }
  }

  /// Withdraw from a project application
  static Future<bool> withdrawProject(String applicationId) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.put(
        path: 'applications/$applicationId/withdraw',
      );

      if (response?.isOk ?? false) {
        return true;
      }
      return false;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st, showSnackBar: false);
      return false;
    }
  }

  /// Get applications for organizer's projects
  static Future<Map<String, dynamic>?> getOrganizerApplications({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: 'applications/organizer/applications',
        params: {
          'page': page,
          'limit': limit,
        },
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? responseData = response?.data;
        if (responseData != null && responseData.containsKey('data')) {
          final Map<String, dynamic> data = responseData['data'];
          if (data.containsKey('projects') && data.containsKey('pagination')) {
            final projectsList = data['projects'];
            final pagination = data['pagination'];

            if (projectsList is List && pagination is Map<String, dynamic>) {
              return {
                'projects': projectsList,
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
      letMeHandleAllErrors(e, st, showSnackBar: false);
      return null;
    } catch (e, st) {
      logE('Unexpected error in getOrganizerApplications: $e\n$st');
      return null;
    }
  }

  /// Withdraw from a project application
  static Future<bool> manageApplication({
    required String applicationId,
    required String status,
  }) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.put(
        path: 'applications/$applicationId',
        data: {
          'status': status,
        },
      );

      if (response?.isOk ?? false) {
        return true;
      }
      return false;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st, showSnackBar: false);
      appSnackbar(
        title: 'Error',
        message: e.response?.data['message'] ?? 'Failed to manage application',
        snackBarState: SnackBarState.DANGER,
      );
      return false;
    }
  }
}
