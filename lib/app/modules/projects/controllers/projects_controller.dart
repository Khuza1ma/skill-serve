import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../data/models/project_model.dart';
import '../../../utils/data_grid_utils.dart';

class ProjectsController extends GetxController {
  DataPagerController dataPagerController = DataPagerController();
  RxInt limit = DataGridUtils.pageSizes.first.obs;
  RxInt currentPageIndex = 0.obs;
  RxInt startPageIndex = (-1).obs;
  final RxList<Project> projects = <Project>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  void loadProjects() {
    isLoading.value = true;

    // Simulate API call with a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      projects.value = [
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
        ),
        Project(
          projectId: 'PRJ003',
          title: 'Database Migration',
          organizerName: 'DataTech Solutions',
          location: 'Chicago',
          description: 'Migrate legacy database to modern cloud solution',
          requiredSkills: ['SQL', 'AWS', 'Database Design'],
          timeCommitment: '20 hours/week',
          startDate: DateTime.now().add(const Duration(days: 21)),
          applicationDeadline: DateTime.now().add(const Duration(days: 60)),
          status: 'Available',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Project(
          projectId: 'PRJ004',
          title: 'UI/UX Redesign',
          organizerName: 'Creative Designs',
          location: 'Austin',
          description: 'Redesign user interface for better accessibility',
          requiredSkills: ['UI/UX', 'Figma', 'Adobe XD'],
          timeCommitment: '12 hours/week',
          startDate: DateTime.now().add(const Duration(days: 10)),
          applicationDeadline: DateTime.now().add(const Duration(days: 40)),
          status: 'Available',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Project(
          projectId: 'PRJ005',
          title: 'API Integration',
          organizerName: 'Integration Solutions',
          location: 'Seattle',
          description:
              'Integrate multiple third-party APIs into existing platform',
          requiredSkills: ['API', 'REST', 'JSON', 'Node.js'],
          timeCommitment: '18 hours/week',
          startDate: DateTime.now().add(const Duration(days: 15)),
          applicationDeadline: DateTime.now().add(const Duration(days: 50)),
          status: 'Available',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ];
      isLoading.value = false;
    });
  }

  double get pageCount {
    return (projects.length / limit.value).ceil().toDouble();
  }
}
