import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/models/project_model.dart';
import '../../../utils/data_grid_utils.dart';

class ProjectsDetailsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final RxList<Project> selectedProject = <Project>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProjectDetails();
  }

  void loadProjectDetails() {
    isLoading.value = true;

    // Simulate API call with a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      selectedProject.value = [
        Project(
          projectId: 'PRJ001',
          title: 'Mobile App Development',
          organizerName: 'Tech Solutions Inc.',
          location: 'New York',
          description: 'Develop a mobile app for community service tracking',
          requiredSkills: ['Flutter', 'Dart', 'Firebase'],
          timeCommitment: '10 hours/week',
          startDate: DateTime.now().add(const Duration(days: 7)),
          applicationDeadline: DateTime.now().add(const Duration(days: 30)),
          status: 'Available',
          createdAt: DateTime.now(),
          endDate: DateTime.now(),
          maxVolunteers: 2,
        ),
        Project(
          projectId: 'PRJ002',
          title: 'Web Portal Design',
          organizerName: 'Community Connect',
          location: 'San Francisco',
          description: 'Design a web portal for volunteer management',
          requiredSkills: ['HTML', 'CSS', 'JavaScript', 'React'],
          timeCommitment: '15 hours/week',
          startDate: DateTime.now().add(const Duration(days: 14)),
          applicationDeadline: DateTime.now().add(const Duration(days: 45)),
          status: 'Available',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          endDate: DateTime.now(),
          maxVolunteers: 3,
        ),
      ];
      isLoading.value = false;
    });
  }

  double get pageCount {
    return (selectedProject.length / limit.value).ceil().toDouble();
  }
}
