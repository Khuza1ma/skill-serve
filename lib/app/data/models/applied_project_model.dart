class AppliedProject {
  final String applicationId;
  final String volunteerId;
  final String projectId;
  final String status;
  final String dateApplied;

  AppliedProject({
    required this.applicationId,
    required this.volunteerId,
    required this.projectId,
    required this.status,
    required this.dateApplied,
  });

  // Factory method to create an AppliedProject from a Map (for JSON parsing)
  factory AppliedProject.fromJson(Map<String, dynamic> json) {
    return AppliedProject(
      applicationId: json['applicationId'] as String,
      volunteerId: json['volunteerId'] as String,
      projectId: json['projectId'] as String,
      status: json['status'] as String,
      dateApplied: json['dateApplied'] as String,
    );
  }

  // Method to convert an AppliedProject to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'volunteerId': volunteerId,
      'projectId': projectId,
      'status': status,
      'dateApplied': dateApplied,
    };
  }
}
