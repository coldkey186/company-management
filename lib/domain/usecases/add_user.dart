// lib/domain/usecases/add_user.dart
import '../entities/user_entity.dart';
import '../../data/models/user_model.dart';  // Import UserModel
import '../../data/repositories/user_repository.dart';

class AddUser {
  final UserRepository userRepository;

  AddUser(this.userRepository);

  Future<void> execute(UserEntity userEntity) async {
    // Chuyển đổi từ UserEntity sang UserModel
    UserModel userModel = UserModel(
      id: userEntity.id,
      name: userEntity.name,
      email: userEntity.email,
      role: userEntity.role,
      department: userEntity.department,  // Thêm department
      branch: userEntity.branch,          // Thêm branch
    );
    
    // Gọi UserRepository để tạo người dùng
    await userRepository.createUser(userModel);
  }
}
