class OrganizerApplication {
  final String projectId;
  final String projectTitle;
  final String projectLocation;
  final String projectStatus;
  final List<Application> applications;

  OrganizerApplication({
    required this.projectId,
    required this.projectTitle,
    required this.projectLocation,
    required this.projectStatus,
    required this.applications,
  });

  OrganizerApplication copyWith({
    String? projectId,
    String? projectTitle,
    String? projectLocation,
    String? projectStatus,
    List<Application>? applications,
  }) =>
      OrganizerApplication(
        projectId: projectId ?? this.projectId,
        projectTitle: projectTitle ?? this.projectTitle,
        projectLocation: projectLocation ?? this.projectLocation,
        projectStatus: projectStatus ?? this.projectStatus,
        applications: applications ?? this.applications,
      );

  factory OrganizerApplication.fromJson(Map<String, dynamic> json) {
    return OrganizerApplication(
      projectId: json['projectId'] ?? '',
      projectTitle: json['projectTitle'] ?? '',
      projectLocation: json['projectLocation'] ?? '',
      projectStatus: json['projectStatus'] ?? '',
      applications: (json['applications'] as List?)
              ?.map((e) => Application.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "projectTitle": projectTitle,
        "projectLocation": projectLocation,
        "projectStatus": projectStatus,
        "applications": applications.map((x) => x.toJson()),
      };
}

class Application {
  final String applicationId;
  final Volunteer volunteer;
  final String status;
  final String dateApplied;

  Application({
    required this.applicationId,
    required this.volunteer,
    required this.status,
    required this.dateApplied,
  });

  Application copyWith({
    String? applicationId,
    Volunteer? volunteer,
    String? status,
    String? dateApplied,
  }) =>
      Application(
        applicationId: applicationId ?? this.applicationId,
        volunteer: volunteer ?? this.volunteer,
        status: status ?? this.status,
        dateApplied: dateApplied ?? this.dateApplied,
      );

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['applicationId'] ?? '',
      volunteer: Volunteer.fromJson(json['volunteer'] ?? {}),
      status: json['status'] ?? '',
      dateApplied: json['dateApplied'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "applicationId": applicationId,
        "volunteer": volunteer.toJson(),
        "status": status,
        "dateApplied": dateApplied,
      };
}

class Volunteer {
  final String id;
  final String username;
  final String email;

  Volunteer({
    required this.id,
    required this.username,
    required this.email,
  });

  Volunteer copyWith({
    String? id,
    String? username,
    String? email,
  }) =>
      Volunteer(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
      );

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
      };
}
