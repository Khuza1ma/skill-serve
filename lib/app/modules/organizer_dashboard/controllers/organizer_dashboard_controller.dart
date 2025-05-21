import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/data/models/organizer_dashboard_model.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/data/remote/services/dashboard_service.dart';
import 'package:skill_serve/app/ui/components/app_snackbar.dart';

class OrganizerDashboardController extends GetxController {
  final RxList<Project> projects = <Project>[].obs;
  final Rx<OrganizerProjectStatusCounts> projectStatusCounts =
      OrganizerProjectStatusCounts(
    totalProjects: 0,
    openProjects: 0,
    assignedProjects: 0,
    completedProjects: 0,
    cancelledProjects: 0,
    closedProjects: 0,
    totalApplications: 0,
    totalVolunteers: 0,
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
      final dashboardData = await DashboardService.getOrganizerDashboard();
      if (dashboardData != null) {
        projects.value = dashboardData.projects;
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
      EasyLoading.dismiss();
    }
  }

  int get totalProjects => projectStatusCounts.value.totalProjects;
  int get openProjects => projectStatusCounts.value.openProjects;
  int get assignedProjects => projectStatusCounts.value.assignedProjects;
  int get completedProjects => projectStatusCounts.value.completedProjects;
  int get cancelledProjects => projectStatusCounts.value.cancelledProjects;
  int get closedProjects => projectStatusCounts.value.closedProjects;
  int get totalApplications => projectStatusCounts.value.totalApplications;
  int get totalVolunteers => projectStatusCounts.value.totalVolunteers;
}
