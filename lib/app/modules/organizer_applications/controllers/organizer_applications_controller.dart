import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:skill_serve/app/modules/organizer_dashboard/controllers/organizer_dashboard_controller.dart';
import 'package:skill_serve/app/ui/components/app_snackbar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:skill_serve/app/utils/data_grid_utils.dart';

import '../../../data/models/organizer_application_model.dart';
import '../../../data/remote/services/project_service.dart';

class OrganizerApplicationsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final RxList<OrganizerApplication> applications =
      <OrganizerApplication>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt totalItems = 0.obs;
  bool _isInitialLoad = true;

  @override
  void onInit() {
    super.onInit();
    limit.value = DataGridUtils.pageSizes.first;
    loadApplications();
  }

  Future<void> loadApplications() async {
    if (isLoading.value && !_isInitialLoad) return;

    isLoading.value = true;
    try {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
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
        totalItems.value = pagination['total'] ?? 0;
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to load applications',
          snackBarState: SnackBarState.DANGER,
        );
      }
    } catch (e) {
      logE('Error loading applications: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while loading applications',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      isLoading.value = false;
      _isInitialLoad = false;
      EasyLoading.dismiss();
    }
  }

  void onPageSizeChanged(int? size) {
    if (size != null && size != limit.value) {
      limit.value = size;
      currentPageIndex.value = 0;
      loadApplications();
    }
  }

  void onPageChanged(int page) {
    if (page != currentPageIndex.value) {
      currentPageIndex.value = page;
      loadApplications();
    }
  }

  double get pageCount {
    if (totalItems.value == 0) return 1;
    final count = (totalItems.value / limit.value).ceil().toDouble();
    return count;
  }

  Future<void> manageApplication({
    required Application application,
    required String status,
  }) async {
    try {
      EasyLoading.show(
        status: '$status+ing...',
        maskType: EasyLoadingMaskType.black,
      );
      bool result = await ProjectService.manageApplication(
        applicationId: application.applicationId,
        status: status.toLowerCase() == 'accept' ? 'accepted' : 'rejected',
      );
      if (result) {
        appSnackbar(
          message: 'Application $status successfully',
          snackBarState: SnackBarState.SUCCESS,
        );
        loadApplications();
        Get.find<OrganizerDashboardController>().loadDashboardData();
      }
    } catch (e) {
      logE('Error managing application: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while managing the application',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
