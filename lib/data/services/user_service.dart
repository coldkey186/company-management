// lib/data/services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm người dùng mới vào Firestore
  Future<void> addUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toFirestore());
  }

  // Lấy thông tin người dùng từ Firestore
  Future<UserModel?> getUserById(String id) async {
    DocumentSnapshot doc = await _db.collection('users').doc(id).get();

    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }
}
