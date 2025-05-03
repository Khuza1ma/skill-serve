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
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppliedProjects();
  }

  void loadAppliedProjects() {
    isLoading.value = true;
    
    // Simulate API call with a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      appliedProjects.value = [
        AppliedProject(
          applicationId: 'APP001',
          volunteerId: 'VOL001',
          projectId: 'PRJ001',
          status: 'Pending',
          dateApplied: '2023-10-15',
        ),
        AppliedProject(
          applicationId: 'APP002',
          volunteerId: 'VOL002',
          projectId: 'PRJ002',
          status: 'Approved',
          dateApplied: '2023-10-16',
        ),
        AppliedProject(
          applicationId: 'APP003',
          volunteerId: 'VOL003',
          projectId: 'PRJ003',
          status: 'Rejected',
          dateApplied: '2023-10-17',
        ),
        AppliedProject(
          applicationId: 'APP004',
          volunteerId: 'VOL001',
          projectId: 'PRJ004',
          status: 'Pending',
          dateApplied: '2023-10-18',
        ),
        AppliedProject(
          applicationId: 'APP005',
          volunteerId: 'VOL004',
          projectId: 'PRJ001',
          status: 'Approved',
          dateApplied: '2023-10-19',
        ),
        AppliedProject(
          applicationId: 'APP006',
          volunteerId: 'VOL005',
          projectId: 'PRJ005',
          status: 'Pending',
          dateApplied: '2023-10-20',
        ),
      ];
      isLoading.value = false;
    });
  }
  
  double get pageCount {
    return (appliedProjects.length / limit.value).ceil().toDouble();
  }
}
