import 'package:dio/dio.dart';
import 'package:skill_serve/app/utils/api_ext.dart';

import '../../config/error_handling.dart';
import '../../config/logger.dart';
import '../../models/volunteer_dashboard_model.dart';
import '../../models/organizer_dashboard_model.dart';
import '../api_service/init_api_service.dart';

class DashboardService {
  /// Get volunteer dashboard data
  static Future<VolunteerDashboardResponse?> getVolunteerDashboard() async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: 'volunteer/dashboard',
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? data = response?.data?['data'];
        if (data != null) {
          logI('Dashboard data: $data');
          return VolunteerDashboardResponse.fromMap(data);
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return null;
    }
  }

  /// Get organizer dashboard data
  static Future<OrganizerDashboardResponse?> getOrganizerDashboard() async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.get(
        path: 'organizer/dashboard',
      );

      if (response?.isOk ?? false) {
        final Map<String, dynamic>? data = response?.data?['data'];
        if (data != null) {
          logI('Organizer dashboard data: $data');
          return OrganizerDashboardResponse.fromMap(data);
        }
      }
      return null;
    } on DioException catch (e, st) {
      letMeHandleAllErrors(e, st);
      return null;
    }
  }
}
