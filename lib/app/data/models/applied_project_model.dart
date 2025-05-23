import 'package:skill_serve/app/data/models/project_model.dart';

class AppliedProject {
  final String? id;
  final String? volunteerId;
  final Project? projectId;
  final String? status;
  final List<dynamic>? skills;
  final DateTime? dateApplied;
  final DateTime? updatedAt;
  final int? v;

  AppliedProject({
    this.id,
    this.volunteerId,
    this.projectId,
    this.status,
    this.skills,
    this.dateApplied,
    this.updatedAt,
    this.v,
  });

  AppliedProject copyWith({
    String? id,
    String? volunteerId,
    Project? projectId,
    String? status,
    List<dynamic>? skills,
    DateTime? dateApplied,
    DateTime? updatedAt,
    int? v,
  }) =>
      AppliedProject(
        id: id ?? this.id,
        volunteerId: volunteerId ?? this.volunteerId,
        projectId: projectId ?? this.projectId,
        status: status ?? this.status,
        skills: skills ?? this.skills,
        dateApplied: dateApplied ?? this.dateApplied,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory AppliedProject.fromJson(Map<String, dynamic> json) => AppliedProject(
        id: json["_id"],
        volunteerId: json["volunteerId"],
        projectId: json["projectId"] == null
            ? null
            : Project.fromJson(json["projectId"]),
        status: json["status"],
        skills: json["skills"] == null
            ? []
            : List<dynamic>.from(json["skills"]!.map((x) => x)),
        dateApplied: json["dateApplied"] == null
            ? null
            : DateTime.parse(json["dateApplied"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "volunteerId": volunteerId,
        "projectId": projectId?.toJson(),
        "status": status,
        "skills":
            skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
        "dateApplied":
            "${dateApplied!.year.toString().padLeft(4, '0')}-${dateApplied!.month.toString().padLeft(2, '0')}-${dateApplied!.day.toString().padLeft(2, '0')}",
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class OrganizerId {
  final String? id;
  final String? username;
  final String? email;

  OrganizerId({
    this.id,
    this.username,
    this.email,
  });

  OrganizerId copyWith({
    String? id,
    String? username,
    String? email,
  }) =>
      OrganizerId(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
      );

  factory OrganizerId.fromJson(Map<String, dynamic> json) => OrganizerId(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
      };
}
