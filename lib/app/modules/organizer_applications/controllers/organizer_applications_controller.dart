import 'package:get/get.dart';
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
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void acceptApplication(Application application) {
    // TODO: Implement accept application logic
  }

  void rejectApplication(Application application) {
    // TODO: Implement reject application logic
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
