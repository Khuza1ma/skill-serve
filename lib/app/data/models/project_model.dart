class Project {
  final String projectId;
  final String title;
  final String? organizerName; // Optional
  final String location;
  final String description;
  final List<String> requiredSkills;
  final String timeCommitment;
  final DateTime startDate;
  final DateTime applicationDeadline;
  final String status; // Could use enum: "Available", "Assigned"
  final String? assignedVolunteerId; // Nullable
  final DateTime createdAt;

  Project({
    required this.projectId,
    required this.title,
    this.organizerName,
    required this.location,
    required this.description,
    required this.requiredSkills,
    required this.timeCommitment,
    required this.startDate,
    required this.applicationDeadline,
    required this.status,
    this.assignedVolunteerId,
    required this.createdAt,
  });

  // Factory method to create a Project from a Map (for JSON parsing)
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      organizerName: json['organizerName'] as String?,
      location: json['location'] as String,
      description: json['description'] as String,
      requiredSkills: List<String>.from(json['requiredSkills']),
      timeCommitment: json['timeCommitment'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      applicationDeadline:
          DateTime.parse(json['applicationDeadline'] as String),
      status: json['status'] as String,
      assignedVolunteerId: json['assignedVolunteerId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Method to convert a Project to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'title': title,
      'organizerName': organizerName,
      'location': location,
      'description': description,
      'requiredSkills': requiredSkills,
      'timeCommitment': timeCommitment,
      'startDate': startDate.toIso8601String(),
      'applicationDeadline': applicationDeadline.toIso8601String(),
      'status': status,
      'assignedVolunteerId': assignedVolunteerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
