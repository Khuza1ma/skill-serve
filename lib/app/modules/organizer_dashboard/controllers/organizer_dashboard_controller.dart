import 'package:get/get.dart';
import 'package:skill_serve/app/data/models/organizer_dashboard_model.dart';
import 'package:skill_serve/app/data/models/project_model.dart';
import 'package:skill_serve/app/data/remote/services/dashboard_service.dart';
import 'package:skill_serve/app/ui/components/app_snackbar.dart';

class OrganizerDashboardController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Project> projects = <Project>[].obs;
  final Rx<OrganizerProjectStatusCounts> projectStatusCounts =
      OrganizerProjectStatusCounts(
        openProjects: 0,
        closedProjects: 0,
        totalApplications: 0,
      ).obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
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
      isLoading.value = false;
    }
  }

  int get totalProjects => projects.length;
  int get openProjects => projectStatusCounts.value.openProjects;
  int get closedProjects => projectStatusCounts.value.closedProjects;
  int get totalApplications => projectStatusCounts.value.totalApplications;
}
