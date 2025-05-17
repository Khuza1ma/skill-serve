import 'package:get/get.dart';

import '../../../data/models/applied_project_model.dart';
import '../../../data/models/volunteer_dashboard_model.dart';
import '../../../data/remote/services/dashboard_service.dart';
import '../../../ui/components/app_snackbar.dart';

class VolunteerDashboardController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<AppliedProject> appliedProjects = <AppliedProject>[].obs;
  final Rx<ProjectStatusCounts> projectStatusCounts =
      ProjectStatusCounts(
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
    isLoading.value = true;
    try {
      final dashboardData = await DashboardService.getVolunteerDashboard();
      if (dashboardData != null) {
        appliedProjects.value = dashboardData.appliedProjects;
        projectStatusCounts.value = dashboardData.projectStatusCounts;
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to load dashboard data',
          snackBarState: SnackBarState.DANGER,
        );
      }
    } catch (e) {
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while loading dashboard data',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      isLoading.value = false;
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
