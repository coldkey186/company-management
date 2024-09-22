// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Chuyển đổi từ Firestore document thành UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      role: data['role'],
    );
  }

  // Chuyển đổi UserModel thành Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
