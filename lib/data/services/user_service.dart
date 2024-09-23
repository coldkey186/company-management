import 'package:company_management/repositories/user_repository.dart';
import 'package:company_management/models/user_model.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  // Lấy danh sách người dùng
  Stream<List<UserModel>> getUsers() {
    return _userRepository.getUsers();
  }

  // Tạo người dùng mới
  Future<void> createUser(String name, String email, String role, String department, String branch) {
    final newUser = UserModel(
      id: '', // Firestore sẽ tự động tạo ID
      name: name,
      email: email,
      role: role,
      department: department,
      branch: branch,
    );
    return _userRepository.addUser(newUser);
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(String userId, String name, String email, String role, String department, String branch) {
    final updatedUser = UserModel(
      id: userId,
      name: name,
      email: email,
      role: role,
      department: department,
      branch: branch,
    );
    return _userRepository.updateUser(userId, updatedUser);
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) {
    return _userRepository.deleteUser(userId);
  }
}
