import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String role;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserModel(
    this.uid,
    this.name,
    this.email,
    this.role, {
    this.createdAt,
    this.updatedAt,
  });

  String getRole() {
    return role;
  }

  Map<String, dynamic> userMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}
