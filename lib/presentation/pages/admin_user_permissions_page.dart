import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserPermissionsPage extends StatefulWidget {
  const AdminUserPermissionsPage({super.key});

  @override
  _AdminUserPermissionsPageState createState() => _AdminUserPermissionsPageState();
}

class _AdminUserPermissionsPageState extends State<AdminUserPermissionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Các biến để lưu user và module hiện được chọn
  String? _selectedUser;
  String? _selectedModule;
  Map<String, dynamic> _userPermissions = {};

  // Các module (chức năng) của hệ thống
  final List<String> _modules = ['tasks', 'user_management', 'proposals'];

  // Các quyền có thể có, bao gồm 'read'
  final List<String> _actions = ['create', 'edit', 'delete', 'duplicate', 'approve', 'read'];

  // Lấy danh sách người dùng từ Firestore
  Future<List<String>> _loadUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.id).toList(); // Trả về danh sách userID
  }

  // Lấy quyền của user cho module đã chọn từ Firestore
  Future<void> _loadPermissions(String userId) async {
    DocumentSnapshot snapshot = await _firestore.collection('users_permissions').doc(userId).get();
    setState(() {
      _userPermissions = snapshot.data() as Map<String, dynamic>? ?? {};
    });
  }

  // Cập nhật quyền hạn cho user và module
  Future<void> _updatePermissions(String userId, String module) async {
    try {
      await _firestore.collection('users_permissions').doc(userId).set({
        module: _userPermissions[module]
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu quyền hạn cho $userId - $module')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu quyền hạn: $e')),
      );
    }
  }

  // Thay đổi quyền của user với module hiện tại
  void _togglePermission(String action, bool value) {
    setState(() {
      if (_selectedModule != null) {
        _userPermissions[_selectedModule!][action] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý quyền hạn người dùng')),
      body: Column(
        children: [
          // Dropdown chọn user
          FutureBuilder<List<String>>(
            future: _loadUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  hint: const Text('Chọn người dùng'),
                  value: _selectedUser,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUser = newValue;
                      _selectedModule = null;
                      _userPermissions.clear();
                    });
                    _loadPermissions(_selectedUser!);
                  },
                  items: snapshot.data!.map<DropdownMenuItem<String>>((String user) {
                    return DropdownMenuItem<String>(
                      value: user,
                      child: Text('User: $user'),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          // Dropdown chọn module (chức năng)
          if (_selectedUser != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                hint: const Text('Chọn chức năng'),
                value: _selectedModule,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModule = newValue;
                  });
                },
                items: _modules.map<DropdownMenuItem<String>>((String module) {
                  return DropdownMenuItem<String>(
                    value: module,
                    child: Text(module),
                  );
                }).toList(),
              ),
            ),
          // Hiển thị danh sách quyền hạn
          if (_selectedModule != null)
            Expanded(
              child: ListView(
                children: _actions.map((action) {
                  return CheckboxListTile(
                    title: Text(action),
                    value: _userPermissions[_selectedModule]?[action] ?? false,
                    onChanged: (bool? value) {
                      _togglePermission(action, value!);
                    },
                  );
                }).toList(),
              ),
            ),
          // Nút lưu quyền hạn
          if (_selectedModule != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _updatePermissions(_selectedUser!, _selectedModule!);
                },
                child: const Text('Lưu quyền hạn'),
              ),
            ),
        ],
      ),
    );
  }
}
