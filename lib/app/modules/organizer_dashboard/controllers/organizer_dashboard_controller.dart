import 'package:get/get.dart';
import 'package:skill_serve/app/data/models/project_model.dart';

class OrganizerDashboardController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Project> projects = <Project>[].obs;
  final RxMap<String, int> projectStatusCounts = <String, int>{}.obs;
  final RxMap<String, dynamic> organizerProfile = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> recentVolunteers =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recentApplications =
      <Map<String, dynamic>>[].obs;

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
      organizerProfile.value = {
        'name': 'Community Helpers Organization',
        'email': 'contact@communityhelpers.org',
        'organizerId': 'ORG001',
        'totalProjects': 12,
        'activeProjects': 5,
        'completedProjects': 7,
        'totalVolunteers': 28,
      };

      // Load mock projects data
      projects.value = [
        Project(
          projectId: 'PRJ-001',
          title: 'Community Garden Development',
          organizerName: 'Community Helpers Organization',
          location: 'Downtown Community Center',
          description:
              'Help us develop a community garden that will provide fresh produce for local food banks and teach gardening skills to community members.',
          requiredSkills: [
            'Gardening',
            'Project Management',
            'Community Outreach'
          ],
          timeCommitment: '10 hours per week',
          startDate: DateTime.now().add(const Duration(days: 15)),
          applicationDeadline: DateTime.now().add(const Duration(days: 7)),
          status: 'Open',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Project(
          projectId: 'PRJ-002',
          title: 'Youth Mentorship Program',
          organizerName: 'Community Helpers Organization',
          location: 'City Youth Center',
          description:
              'Mentor underprivileged youth in academic subjects and life skills to help them achieve their full potential.',
          requiredSkills: ['Teaching', 'Mentoring', 'Communication'],
          timeCommitment: '5 hours per week',
          startDate: DateTime.now().add(const Duration(days: 10)),
          applicationDeadline: DateTime.now().add(const Duration(days: 5)),
          status: 'Open',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Project(
          projectId: 'PRJ-003',
          title: 'Homeless Shelter Support',
          organizerName: 'Community Helpers Organization',
          location: 'Downtown Shelter',
          description:
              'Assist in running the local homeless shelter, including meal preparation, distribution of supplies, and administrative support.',
          requiredSkills: ['Organization', 'Food Preparation', 'Compassion'],
          timeCommitment: '8 hours per week',
          startDate: DateTime.now().add(const Duration(days: 7)),
          applicationDeadline: DateTime.now().add(const Duration(days: 3)),
          status: 'Closed',
          assignedVolunteerId: 'VOL-002',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Project(
          projectId: 'PRJ-004',
          title: 'Senior Citizen Tech Support',
          organizerName: 'Community Helpers Organization',
          location: 'Senior Living Center',
          description:
              'Provide technology assistance and training to senior citizens to help them stay connected with family and access online resources.',
          requiredSkills: ['Technology', 'Patience', 'Teaching'],
          timeCommitment: '6 hours per week',
          startDate: DateTime.now().add(const Duration(days: 5)),
          applicationDeadline: DateTime.now().add(const Duration(days: 2)),
          status: 'Open',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Project(
          projectId: 'PRJ-005',
          title: 'Environmental Cleanup',
          organizerName: 'Community Helpers Organization',
          location: 'City Park',
          description:
              'Join our team to clean up local parks and waterways to protect wildlife and improve community spaces.',
          requiredSkills: ['Environmental Awareness', 'Teamwork'],
          timeCommitment: '4 hours per week',
          startDate: DateTime.now().add(const Duration(days: 3)),
          applicationDeadline: DateTime.now().add(const Duration(days: 1)),
          status: 'Closed',
          assignedVolunteerId: 'VOL-005',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      // Mock recent volunteers
      recentVolunteers.value = [
        {
          'id': 'VOL-001',
          'name': 'John Smith',
          'skills': ['Gardening', 'Teaching'],
          'joinedDate': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': 'VOL-002',
          'name': 'Sarah Johnson',
          'skills': ['Project Management', 'Communication'],
          'joinedDate': DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          'id': 'VOL-003',
          'name': 'Michael Brown',
          'skills': ['Technology', 'Mentoring'],
          'joinedDate': DateTime.now().subtract(const Duration(days: 5)),
        },
      ];

      // Mock recent applications
      recentApplications.value = [
        {
          'id': 'APP-001',
          'projectId': 'PRJ-001',
          'projectTitle': 'Community Garden Development',
          'volunteerId': 'VOL-004',
          'volunteerName': 'Emily Davis',
          'status': 'Pending',
          'appliedDate': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'id': 'APP-002',
          'projectId': 'PRJ-002',
          'projectTitle': 'Youth Mentorship Program',
          'volunteerId': 'VOL-005',
          'volunteerName': 'David Wilson',
          'status': 'Approved',
          'appliedDate': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': 'APP-003',
          'projectId': 'PRJ-004',
          'projectTitle': 'Senior Citizen Tech Support',
          'volunteerId': 'VOL-006',
          'volunteerName': 'Jessica Martinez',
          'status': 'Pending',
          'appliedDate': DateTime.now().subtract(const Duration(days: 1)),
        },
      ];

      // Calculate status counts for the chart
      calculateStatusCounts();

      isLoading.value = false;
    });
  }

  void calculateStatusCounts() {
    final Map<String, int> counts = {};

    for (final project in projects) {
      counts[project.status] = (counts[project.status] ?? 0) + 1;
    }

    projectStatusCounts.value = counts;
  }

  int get totalProjects => projects.length;

  int getStatusCount(String status) {
    return projectStatusCounts[status] ?? 0;
  }

  int get openProjects => getStatusCount('Open');
  int get closedProjects => getStatusCount('Closed');
  int get totalApplications => recentApplications.length;

  int getApplicationStatusCount(String status) {
    return recentApplications.where((app) => app['status'] == status).length;
  }
}
