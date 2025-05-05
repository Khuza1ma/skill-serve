// To parse this JSON data, do
//
//     final userEntity = userEntityFromMap(jsonString);

// ignore_for_file: public_member_api_docs
import 'dart:convert';

class User {
  User({
    required this.currentUserId,
    required this.currentUsername,
    required this.currentUserEmail,
    required this.currentUserRole,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        currentUserId: json['_id'] as String? ?? '',
        currentUsername: json['username'] as String? ?? '',
        currentUserEmail: json['email'] as String? ?? '',
        currentUserRole: json['role'] as String? ?? '',
      );

  factory User.fromJson(String json) {
    final Map<String, dynamic> jsonMap =
        jsonDecode(json) as Map<String, dynamic>;
    return User.fromMap(jsonMap);
  }
  String? currentUserId;
  String? currentUsername;
  String? currentUserEmail;
  String? currentUserRole;

  Map<String, dynamic> toJson() {
    final json = {
      '_id': currentUserId,
      'username': currentUsername,
      'email': currentUserEmail,
      'role': currentUserRole,
    };
    return json;
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'current_user_id': currentUserId,
        'current_username': currentUsername,
        'current_user_email': currentUserEmail,
        'current_user_role': currentUserRole,
      };
}
