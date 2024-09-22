import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionChecker {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm kiểm tra quyền hạn của user đối với một module và hành động cụ thể
  Future<bool> hasPermission(String userId, String module, String action) async {
    try {
      // Lấy thông tin quyền hạn của user từ Firestore
      DocumentSnapshot userPermissionsSnapshot = await _firestore.collection('users_permissions').doc(userId).get();
      Map<String, dynamic>? userPermissions = userPermissionsSnapshot.data() as Map<String, dynamic>?;

      // Kiểm tra quyền hạn trong module được chỉ định
      if (userPermissions != null && userPermissions.containsKey(module)) {
        return userPermissions[module][action] ?? false; // Trả về quyền hạn của action
      }
    } catch (e) {
      print('Lỗi khi kiểm tra quyền hạn: $e');
    }
    return false; // Trả về false nếu không có quyền
  }
}
