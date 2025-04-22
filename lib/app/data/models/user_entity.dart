// To parse this JSON data, do
//
//     final userEntity = userEntityFromMap(jsonString);

// ignore_for_file: public_member_api_docs
import 'dart:convert';

class User {
  User({
    required this.currentUsername,
    required this.currentUserId,
    required this.currentUserEmail,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        currentUsername: json['current_username'] as String? ?? '',
        currentUserId: json['current_user_id'] as int? ?? 0,
        currentUserEmail: json['current_email'] as String? ?? '',
      );

  factory User.fromJson(String str) =>
      User.fromMap(json.decode(str) as Map<String, dynamic>);

  String? currentUsername;
  int? currentUserId;
  String? currentUserEmail;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        'current_username': currentUsername,
        'current_user_id': currentUserId,
        'current_user_email': currentUserEmail,
      };
}
