import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../data/models/project_model.dart';
import '../../../utils/data_grid_utils.dart';

class ProjectsDetailsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final Rx<Project?> selectedProject = Rx<Project?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProjectDetails();
  }

  void loadProjectDetails() {
    selectedProject.value = Project(
      projectId: '1',
      title: 'Sample Project',
      organizerName: 'Organization Name',
      location: 'New York',
      description: 'This is a sample project description',
      requiredSkills: ['Flutter', 'Dart', 'Firebase'],
      timeCommitment: '10 hours/week',
      startDate: DateTime.now().add(const Duration(days: 7)),
      applicationDeadline: DateTime.now().add(const Duration(days: 30)),
      status: 'Available',
      createdAt: DateTime.now(),
    );
  }
}
