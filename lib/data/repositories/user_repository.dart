import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_management/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách người dùng
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }
  // Định nghĩa phương thức createUser
  Future<void> createUser(UserModel user) {
    return _firestore.collection('users').add(user.toMap());
  }
  // Thêm người dùng mới
  Future<void> addUser(UserModel user) {
    return _firestore.collection('users').add(user.toMap());
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(String userId, UserModel user) {
    return _firestore.collection('users').doc(userId).update(user.toMap());
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) {
    return _firestore.collection('users').doc(userId).delete();
  }
}
