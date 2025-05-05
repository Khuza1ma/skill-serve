import 'package:get/get.dart';
import '../../../data/models/applied_project_model.dart';

class VolunteerDashboardController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<AppliedProject> appliedProjects = <AppliedProject>[].obs;
  final RxMap<String, int> projectStatusCounts = <String, int>{}.obs;
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() {
    isLoading.value = true;

    // Simulate API call with a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // Load mock profile data
      userProfile.value = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'volunteerId': 'VOL001',
        'skills': ['Flutter', 'Dart', 'Firebase', 'UI/UX Design'],
        'completedProjects': 5,
        'ongoingProjects': 2,
      };

      // Load mock applied projects data
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
          volunteerId: 'VOL001',
          projectId: 'PRJ002',
          status: 'Approved',
          dateApplied: '2023-10-16',
        ),
        AppliedProject(
          applicationId: 'APP004',
          volunteerId: 'VOL001',
          projectId: 'PRJ004',
          status: 'Pending',
          dateApplied: '2023-10-18',
        ),
        AppliedProject(
          applicationId: 'APP007',
          volunteerId: 'VOL001',
          projectId: 'PRJ007',
          status: 'Rejected',
          dateApplied: '2023-10-21',
        ),
        AppliedProject(
          applicationId: 'APP009',
          volunteerId: 'VOL001',
          projectId: 'PRJ009',
          status: 'Approved',
          dateApplied: '2023-10-25',
        ),
      ];

      // Calculate status counts for the chart
      calculateStatusCounts();

      isLoading.value = false;
    });
  }

  void calculateStatusCounts() {
    final Map<String, int> counts = {};

    for (final project in appliedProjects) {
      counts[project.status] = (counts[project.status] ?? 0) + 1;
    }

    projectStatusCounts.value = counts;
  }

  int get totalAppliedProjects => appliedProjects.length;

  int getStatusCount(String status) {
    return projectStatusCounts[status] ?? 0;
  }
}
