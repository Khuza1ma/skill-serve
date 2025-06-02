import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/models/project_model.dart';
import '../../../data/remote/services/project_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/data_grid_utils.dart';
import '../../volunteer_dashboard/controllers/volunteer_dashboard_controller.dart';

class ProjectsDetailsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final RxList<Project> selectedProject = <Project>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt totalItems = 0.obs;
  bool _isInitialLoad = true;

  @override
  void onInit() {
    super.onInit();
    // Ensure initial limit is set correctly
    limit.value = DataGridUtils.pageSizes.first;
    loadProjectDetails();
  }

  Future<void> loadProjectDetails() async {
    if (isLoading.value && !_isInitialLoad) return;

    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final result = await ProjectService.fetchProjects(
        skip: currentPageIndex.value * limit.value,
        limit: limit.value,
        page: currentPageIndex.value + 1,
      );

      if (result != null) {
        final projects = result['projects'] as List<Project>;
        final pagination = result['pagination'] as Map<String, dynamic>;

        selectedProject.value = projects;
        totalItems.value = pagination['total'] ?? 0;
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to load project details',
          snackBarState: SnackBarState.danger,
        );
      }
    } catch (e) {
      logE('Error loading project details: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while loading project details',
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
      loadProjectDetails();
    }
  }

  void onPageChanged(int page) {
    if (page != currentPageIndex.value) {
      currentPageIndex.value = page;
      loadProjectDetails();
    }
  }

  double get pageCount {
    if (totalItems.value == 0) return 1;
    final count = (totalItems.value / limit.value).ceil().toDouble();
    return count;
  }

  Future<void> applyProject(String projectId) async {
    try {
      EasyLoading.show(
        status: 'Applying...',
        maskType: EasyLoadingMaskType.black,
      );
      final success = await ProjectService.applyProject(projectId);

      if (success) {
        Get.find<VolunteerDashboardController>().loadDashboardData();
        appSnackbar(
          title: 'Success',
          message: 'Successfully applied for the project',
          snackBarState: SnackBarState.success,
        );
        loadProjectDetails();
      }
    } catch (e) {
      logE('Error applying for project: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while applying for the project',
        snackBarState: SnackBarState.danger,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
