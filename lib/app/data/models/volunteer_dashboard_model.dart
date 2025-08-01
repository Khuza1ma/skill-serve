import 'applied_project_model.dart';

class ProjectStatusCounts {
  final int pending;
  final int approved;
  final int rejected;
  final int totalAppliedProjects;

  ProjectStatusCounts({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.totalAppliedProjects,
  });

  factory ProjectStatusCounts.fromMap(Map<String, dynamic> json) {
    return ProjectStatusCounts(
      pending: json['pending'] ?? 0,
      approved: json['approved'] ?? 0,
      rejected: json['rejected'] ?? 0,
      totalAppliedProjects: json['total_applied_projects'] ?? 0,
    );
  }
}

class VolunteerDashboardResponse {
  final ProjectStatusCounts projectStatusCounts;
  final List<AppliedProject> appliedProjects;

  VolunteerDashboardResponse({
    required this.projectStatusCounts,
    required this.appliedProjects,
  });

  factory VolunteerDashboardResponse.fromMap(Map<String, dynamic> json) {
    return VolunteerDashboardResponse(
      projectStatusCounts: ProjectStatusCounts.fromMap(
        json['project_status_counts'],
      ),
      appliedProjects: (json['applied_projects'] as List)
          .map((project) => AppliedProject.fromJson(project))
          .toList(),
    );
  }
}
