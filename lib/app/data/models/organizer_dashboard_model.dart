import 'project_model.dart';

class OrganizerProjectStatusCounts {
  final int openProjects;
  final int closedProjects;
  final int totalApplications;

  OrganizerProjectStatusCounts({
    required this.openProjects,
    required this.closedProjects,
    required this.totalApplications,
  });

  factory OrganizerProjectStatusCounts.fromMap(Map<String, dynamic> json) {
    return OrganizerProjectStatusCounts(
      openProjects: json['openProjects'] ?? 0,
      closedProjects: json['closedProjects'] ?? 0,
      totalApplications: json['totalApplications'] ?? 0,
    );
  }
}

class OrganizerDashboardResponse {
  final OrganizerProjectStatusCounts projectStatusCounts;
  final List<Project> projects;

  OrganizerDashboardResponse({
    required this.projectStatusCounts,
    required this.projects,
  });

  factory OrganizerDashboardResponse.fromMap(Map<String, dynamic> json) {
    return OrganizerDashboardResponse(
      projectStatusCounts: OrganizerProjectStatusCounts.fromMap(
        json['projectStatusCounts'],
      ),
      projects:
          (json['projects'] as List)
              .map((project) => Project.fromJson(project))
              .toList(),
    );
  }
}
