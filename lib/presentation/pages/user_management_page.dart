import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_management/permissions/permission_checker.dart';

class UserManagementPage extends StatefulWidget {
  final String userId;
  final PermissionChecker _permissionChecker = PermissionChecker();

  UserManagementPage({super.key, required this.userId});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool _isLoading = false; // Trạng thái loading
  String? _errorMessage; // Lưu trữ thông báo lỗi

  // Hiển thị thông báo lỗi nếu có
  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink(); // Nếu không có lỗi, không hiển thị gì
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  // Kiểm tra quyền và tạo người dùng mới nếu có quyền
  Future<void> _createUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset lỗi trước khi thao tác
    });

    try {
      bool canCreate = await widget._permissionChecker.hasPermission(widget.userId, 'user_management', 'create');
      if (canCreate) {
        await FirebaseFirestore.instance.collection('users').add({
          'name': 'Người dùng mới',
          'email': 'newuser@example.com',
          'createdAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Người dùng đã được tạo')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền tạo người dùng';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tạo người dùng: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và chỉnh sửa người dùng nếu có quyền
  Future<void> _editUser(BuildContext context, String userIdToEdit) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canEdit = await widget._permissionChecker.hasPermission(widget.userId, 'user_management', 'edit');
      if (canEdit) {
        await FirebaseFirestore.instance.collection('users').doc(userIdToEdit).update({
          'name': 'Người dùng đã chỉnh sửa',
          'updatedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Người dùng đã được chỉnh sửa')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền chỉnh sửa người dùng';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi chỉnh sửa người dùng: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và xóa người dùng nếu có quyền
  Future<void> _deleteUser(BuildContext context, String userIdToDelete) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canDelete = await widget._permissionChecker.hasPermission(widget.userId, 'user_management', 'delete');
      if (canDelete) {
        await FirebaseFirestore.instance.collection('users').doc(userIdToDelete).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Người dùng đã được xóa')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền xóa người dùng';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xóa người dùng: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và hiển thị danh sách người dùng nếu có quyền (read)
  Future<void> _readUsers(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canRead = await widget._permissionChecker.hasPermission(widget.userId, 'user_management', 'read');
      if (canRead) {
        QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
        for (var user in usersSnapshot.docs) {
          print('Người dùng: ${user['name']} - ${user['email']}');
        }
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền xem người dùng';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xem người dùng: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn chờ khi đang xử lý
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _createUser(context),
                    child: const Text('Tạo người dùng mới'),
                  ),
                  ElevatedButton(
                    onPressed: () => _editUser(context, 'userID123'),
                    child: const Text('Chỉnh sửa người dùng'),
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteUser(context, 'userID123'),
                    child: const Text('Xóa người dùng'),
                  ),
                  ElevatedButton(
                    onPressed: () => _readUsers(context),
                    child: const Text('Xem danh sách người dùng'),
                  ),
                  _buildErrorMessage(), // Hiển thị lỗi nếu có
                ],
              ),
            ),
    );
  }
}
