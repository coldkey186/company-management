// lib/data/repositories/user_repository.dart
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();

  // Tạo người dùng trong Firestore
  Future<void> createUser(UserModel user) async {
    return _userService.addUser(user);
  }

  // Fetch user thông qua UserService
  Future<UserModel?> fetchUser(String id) {
    return _userService.getUserById(id);
  }
}
