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
      openProjects: json['open_projects'] ?? 0,
      closedProjects: json['closed_projects'] ?? 0,
      totalApplications: json['total_applications'] ?? 0,
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
        json['project_status_counts'],
      ),
      projects: (json['projects'] as List)
          .map((project) => Project.fromJson(project))
          .toList(),
    );
  }
}
