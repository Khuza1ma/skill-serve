class Project {
  final String? title;
  final String? organizerName;
  final String? organizerId;
  final String? location;
  final String? description;
  final List<String>? requiredSkills;
  final String? timeCommitment;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? applicationDeadline;
  final String? status;
  final List<int>? assignedVolunteerId;
  final String? contactEmail;
  final int? maxVolunteers;
  final DateTime? createdAt;
  final String? projectId;
  final DateTime? updatedAt;
  final int? v;
  final String? category;

  Project({
    this.title,
    this.organizerName,
    this.organizerId,
    this.location,
    this.description,
    this.requiredSkills,
    this.timeCommitment,
    this.startDate,
    this.endDate,
    this.applicationDeadline,
    this.status,
    this.assignedVolunteerId,
    this.contactEmail,
    this.maxVolunteers,
    this.createdAt,
    this.projectId,
    this.updatedAt,
    this.v,
    this.category,
  });

  Project copyWith({
    String? title,
    String? organizerName,
    String? organizerId,
    String? location,
    String? description,
    List<String>? requiredSkills,
    String? timeCommitment,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? applicationDeadline,
    String? status,
    int? assignedVolunteerId,
    String? contactEmail,
    int? maxVolunteers,
    DateTime? createdAt,
    String? id,
    DateTime? updatedAt,
    int? v,
    String? category,
  }) =>
      Project(
        title: title ?? this.title,
        organizerName: organizerName ?? this.organizerName,
        organizerId: organizerId ?? this.organizerId,
        location: location ?? this.location,
        description: description ?? this.description,
        requiredSkills: requiredSkills ?? this.requiredSkills,
        timeCommitment: timeCommitment ?? this.timeCommitment,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        applicationDeadline: applicationDeadline ?? this.applicationDeadline,
        status: status ?? this.status,
        assignedVolunteerId:
            assignedVolunteerId == null ? null : [assignedVolunteerId],
        contactEmail: contactEmail ?? this.contactEmail,
        maxVolunteers: maxVolunteers ?? this.maxVolunteers,
        createdAt: createdAt ?? this.createdAt,
        projectId: id ?? projectId,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        category: category ?? this.category,
      );

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        title: json["title"],
        organizerName: json["organizer_name"],
        organizerId: json["organizer_id"],
        location: json["location"],
        description: json["description"],
        requiredSkills: json["required_skills"] == null
            ? []
            : List<String>.from(json["required_skills"]!.map((x) => x)),
        timeCommitment: json["time_commitment"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        applicationDeadline: json["application_deadline"] == null
            ? null
            : DateTime.parse(json["application_deadline"]),
        status: json["status"],
        assignedVolunteerId: json["assigned_volunteer_id"] == null
            ? []
            : List<int>.from(json["assigned_volunteer_id"]!.map((x) => x)),
        contactEmail: json["contact_email"],
        maxVolunteers: json["max_volunteers"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        projectId: json["_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        v: json["__v"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "organizer_name": organizerName,
        "organizer_id": organizerId,
        "location": location,
        "description": description,
        "required_skills": requiredSkills == null
            ? []
            : List<dynamic>.from(requiredSkills!.map((x) => x)),
        "time_commitment": timeCommitment,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "application_deadline": applicationDeadline?.toIso8601String(),
        "status": status,
        "assigned_volunteer_id": assignedVolunteerId,
        "contact_email": contactEmail,
        "max_volunteers": maxVolunteers,
        "created_at": createdAt?.toIso8601String(),
        "_id": projectId,
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
        "category": category,
      };
}
