import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';

import '../../volunteer_dashboard/controllers/volunteer_dashboard_controller.dart';
import '../../../data/remote/services/project_service.dart';
import '../../../data/models/applied_project_model.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/data_grid_utils.dart';
import '../../../data/config/logger.dart';

class AppliedProjectsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final RxList<AppliedProject> appliedProjects = <AppliedProject>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt totalItems = 0.obs;
  bool _isInitialLoad = true;

  @override
  void onInit() {
    super.onInit();
    // Ensure initial limit is set correctly
    limit.value = DataGridUtils.pageSizes.first;
    loadAppliedProjects();
  }

  Future<void> loadAppliedProjects() async {
    if (isLoading.value && !_isInitialLoad) return;

    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final result = await ProjectService.getAppliedProjects(
        page: currentPageIndex.value + 1,
        limit: limit.value,
      );

      if (result != null) {
        final applications = result['applications'] as List<AppliedProject>;
        final pagination = result['pagination'] as Map<String, dynamic>;

        appliedProjects.value = applications;
        totalItems.value = pagination['total'] ?? 0;
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to load applied projects',
          snackBarState: SnackBarState.danger,
        );
      }
    } catch (e) {
      logE('Error loading applied projects: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while loading applied projects',
        snackBarState: SnackBarState.danger,
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
      loadAppliedProjects();
    }
  }

  void onPageChanged(int page) {
    if (page != currentPageIndex.value) {
      currentPageIndex.value = page;
      loadAppliedProjects();
    }
  }

  double get pageCount {
    if (totalItems.value == 0) return 1;
    final count = (totalItems.value / limit.value).ceil().toDouble();
    return count;
  }

  Future<void> withdrawProject(String applicationId) async {
    try {
      EasyLoading.show(
        status: 'Withdrawing...',
        maskType: EasyLoadingMaskType.black,
      );
      final success = await ProjectService.withdrawProject(applicationId);

      if (success) {
        appSnackbar(
          title: 'Success',
          message: 'Successfully withdrew from the project',
          snackBarState: SnackBarState.success,
        );
        // Refresh the applied projects list
        Get.find<VolunteerDashboardController>().loadDashboardData();
        loadAppliedProjects();
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to withdraw from the project',
          snackBarState: SnackBarState.danger,
        );
      }
    } catch (e) {
      logE('Error withdrawing from project: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while withdrawing from the project',
        snackBarState: SnackBarState.danger,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
