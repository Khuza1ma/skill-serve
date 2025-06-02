import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';

import '../../../data/models/applied_project_model.dart';
import '../../../data/models/volunteer_dashboard_model.dart';
import '../../../data/remote/services/dashboard_service.dart';
import '../../../ui/components/app_snackbar.dart';

class VolunteerDashboardController extends GetxController {
  final RxList<AppliedProject> appliedProjects = <AppliedProject>[].obs;
  final Rx<ProjectStatusCounts> projectStatusCounts = ProjectStatusCounts(
    pending: 0,
    approved: 0,
    rejected: 0,
    totalAppliedProjects: 0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final dashboardData = await DashboardService.getVolunteerDashboard();
      if (dashboardData != null) {
        appliedProjects.value = dashboardData.appliedProjects;
        projectStatusCounts.value = dashboardData.projectStatusCounts;
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to load dashboard data',
          snackBarState: SnackBarState.danger,
        );
      }
    } catch (e, st) {
      logE('$e,$st');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while loading dashboard data',
        snackBarState: SnackBarState.danger,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  int get totalAppliedProjects =>
      projectStatusCounts.value.totalAppliedProjects;

  int getStatusCount(String status) {
    switch (status) {
      case 'Pending':
        return projectStatusCounts.value.pending;
      case 'Approved':
        return projectStatusCounts.value.approved;
      case 'Rejected':
        return projectStatusCounts.value.rejected;
      default:
        return 0;
    }
  }
}
