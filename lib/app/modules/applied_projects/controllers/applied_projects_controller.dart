import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../data/models/applied_project_model.dart';
import '../../../utils/data_grid_utils.dart';

class AppliedProjectsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final RxList<AppliedProject> appliedProjects = <AppliedProject>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAppliedProjects();
  }

  void loadAppliedProjects() {
    // Sample data - in a real app, this would come from an API or database
    appliedProjects.value = [
      AppliedProject(
        applicationId: '1',
        volunteerId: 'V001',
        projectId: 'P001',
        status: 'Pending',
        dateApplied: '2023-10-15',
      ),
      AppliedProject(
        applicationId: '2',
        volunteerId: 'V002',
        projectId: 'P002',
        status: 'Approved',
        dateApplied: '2023-10-16',
      ),
      AppliedProject(
        applicationId: '3',
        volunteerId: 'V003',
        projectId: 'P003',
        status: 'Rejected',
        dateApplied: '2023-10-17',
      ),
    ];
  }
}
