// lib/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;  // Thêm thuộc tính department
  final String branch;      // Thêm thuộc tính branch

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,  // Khởi tạo department
    required this.branch,      // Khởi tạo branch
  });
}
