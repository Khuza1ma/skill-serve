import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/modules/organizer_dashboard/controllers/organizer_dashboard_controller.dart';
import 'package:skill_serve/app/ui/components/app_snackbar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/models/organizer_application_model.dart';
import '../../../data/remote/services/project_service.dart';

class OrganizerApplicationsController extends GetxController {
  final isLoading = false.obs;
  final applications = <OrganizerApplication>[].obs;
  final currentPageIndex = 0.obs;
  final startPageIndex = 0.obs;
  final pageCount = 1.obs;
  final limit = 10.obs;
  final dataPagerController = DataPagerController();

  @override
  void onInit() {
    super.onInit();
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    try {
      isLoading.value = true;
      final result = await ProjectService.getOrganizerApplications(
        page: currentPageIndex.value + 1,
        limit: limit.value,
      );

      if (result != null) {
        final projects = (result['projects'] as List)
            .map((e) => OrganizerApplication.fromJson(e))
            .toList();
        applications.value = projects;

        final pagination = result['pagination'] as Map<String, dynamic>;
        pageCount.value = pagination['pages'] ?? 1;
      }
    } catch (e) {
      logE(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> manageApplication({
    required Application application,
    required String status,
  }) async {
    try {
      bool result = await ProjectService.manageApplication(
        applicationId: application.applicationId,
        status: status.toLowerCase() == 'accept' ? 'accepted' : 'rejected',
      );
      if (result) {
        appSnackbar(
          message: 'Application $status successfully',
          snackBarState: SnackBarState.SUCCESS,
        );
        fetchApplications();
        Get.find<OrganizerDashboardController>().loadDashboardData();
      }
    } catch (e) {
      logE(e);
    }
  }

  void setStartPageIndex(int index) {
    startPageIndex.value = index;
  }

  void setLimit(int? newLimit) {
    if (newLimit != null) {
      limit.value = newLimit;
      fetchApplications();
    }
  }
}
