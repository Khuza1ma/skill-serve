import 'package:get/get.dart';
import 'package:skill_serve/app/data/config/logger.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/models/project_model.dart';
import '../../../data/remote/services/project_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/data_grid_utils.dart';

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
    // Only prevent multiple loads if it's not the initial load
    if (isLoading.value && !_isInitialLoad) return;

    isLoading.value = true;
    try {
      final result = await ProjectService.fetchProjects(
        page: currentPageIndex.value + 1, // API uses 1-based indexing
        limit: limit.value,
      );

      if (result != null) {
        final projects = result['projects'] as List<Project>;
        final pagination = result['pagination'] as Map<String, dynamic>;

        selectedProject.value = projects;
        totalItems.value = pagination['total'] ?? 0;

        // Verify the data
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to load project details',
          snackBarState: SnackBarState.DANGER,
        );
      }
    } catch (e) {
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while loading project details',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      isLoading.value = false;
      _isInitialLoad = false;
    }
  }

  void updateLimit(int? newLimit) {
    if (newLimit != null && newLimit != limit.value) {
      limit.value = newLimit;
      currentPageIndex.value = 0;
      loadProjectDetails();
    }
  }

  void updateStartPageIndex(int index) {
    startPageIndex.value = index;
  }

  double get pageCount {
    if (totalItems.value == 0) return 1;
    final count = (totalItems.value / limit.value).ceil().toDouble();
    return count;
  }

  Future<void> applyProject(String projectId) async {
    try {
      isLoading.value = true;
      final success = await ProjectService.applyProject(projectId);

      if (success) {
        appSnackbar(
          title: 'Success',
          message: 'Successfully applied for the project',
          snackBarState: SnackBarState.SUCCESS,
        );
        loadProjectDetails();
      } else {
        appSnackbar(
          title: 'Error',
          message: 'Failed to apply for the project',
          snackBarState: SnackBarState.DANGER,
        );
      }
    } catch (e) {
      logE('Error applying for project: $e');
      appSnackbar(
        title: 'Error',
        message: 'An error occurred while applying for the project',
        snackBarState: SnackBarState.DANGER,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
