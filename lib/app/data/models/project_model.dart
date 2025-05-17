class Project {
  final String projectId;
  final String title;
  final String? organizerName;
  final String? organizerId;
  final String location;
  final String description;
  final List<String> requiredSkills;
  final String timeCommitment;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime applicationDeadline;
  final String? status;
  final String? assignedVolunteerId;
  final String? contactEmail;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int maxVolunteers;

  Project({
    required this.projectId,
    required this.title,
    this.organizerName,
    this.organizerId,
    required this.location,
    required this.description,
    required this.requiredSkills,
    required this.timeCommitment,
    required this.startDate,
    required this.endDate,
    required this.applicationDeadline,
    this.status,
    this.assignedVolunteerId,
    this.contactEmail,
    this.createdAt,
    this.updatedAt,
    required this.maxVolunteers,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['_id'] as String,
      title: json['title'] as String,
      organizerName: json['organizer_name'] as String,
      organizerId: json['organizer_id'] as String?,
      location: json['location'] as String,
      description: json['description'] as String,
      requiredSkills: List<String>.from(json['required_skills']),
      timeCommitment: json['time_commitment'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      applicationDeadline:
          DateTime.parse(json['application_deadline'] as String),
      status: json['status'] as String,
      assignedVolunteerId: json['assigned_volunteer_id'] as String?,
      contactEmail: json['contact_email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      maxVolunteers: json['max_volunteers'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'status': status,
      'required_skills': requiredSkills,
      'time_commitment': timeCommitment,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'application_deadline': applicationDeadline.toIso8601String(),
      'max_volunteers': maxVolunteers,
    };
  }
}
