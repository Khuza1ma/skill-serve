import 'project_model.dart';

class OrganizerProjectStatusCounts {
  final int totalProjects;
  final int openProjects;
  final int assignedProjects;
  final int completedProjects;
  final int cancelledProjects;
  final int closedProjects;
  final int totalApplications;
  final int totalVolunteers;

  OrganizerProjectStatusCounts({
    required this.totalProjects,
    required this.openProjects,
    required this.assignedProjects,
    required this.completedProjects,
    required this.cancelledProjects,
    required this.closedProjects,
    required this.totalApplications,
    required this.totalVolunteers,
  });

  factory OrganizerProjectStatusCounts.fromMap(Map<String, dynamic> json) {
    return OrganizerProjectStatusCounts(
      totalProjects: json['total_projects'] ?? 0,
      openProjects: json['open_projects'] ?? 0,
      assignedProjects: json['assigned_projects'] ?? 0,
      completedProjects: json['completed_projects'] ?? 0,
      cancelledProjects: json['cancelled_projects'] ?? 0,
      closedProjects: json['closed_projects'] ?? 0,
      totalApplications: json['total_applications'] ?? 0,
      totalVolunteers: json['total_volunteers'] ?? 0,
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
