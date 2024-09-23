import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_management/permissions/permission_checker.dart';

class TaskManagementPage extends StatefulWidget {
  final String userId;
  final PermissionChecker _permissionChecker = PermissionChecker();

  TaskManagementPage({super.key, required this.userId});

  @override
  _TaskManagementPageState createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  bool _isLoading = false; // Trạng thái loading để kiểm soát UI
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

  // Kiểm tra quyền và tạo công việc mới nếu có quyền
  Future<void> _createTask(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset lỗi trước khi thao tác
    });

    try {
      bool canCreate = await widget._permissionChecker.hasPermission(widget.userId, 'tasks', 'create');
      if (canCreate) {
        await FirebaseFirestore.instance.collection('tasks').add({
          'title': 'Công việc mới',
          'description': 'Mô tả công việc',
          'createdAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Công việc đã được tạo')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền tạo công việc';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tạo công việc: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và chỉnh sửa công việc nếu có quyền
  Future<void> _editTask(BuildContext context, String taskId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canEdit = await widget._permissionChecker.hasPermission(widget.userId, 'tasks', 'edit');
      if (canEdit) {
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
          'title': 'Công việc đã chỉnh sửa',
          'updatedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Công việc đã được chỉnh sửa')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền chỉnh sửa công việc';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi chỉnh sửa công việc: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và xóa công việc nếu có quyền
  Future<void> _deleteTask(BuildContext context, String taskId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canDelete = await widget._permissionChecker.hasPermission(widget.userId, 'tasks', 'delete');
      if (canDelete) {
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Công việc đã được xóa')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền xóa công việc';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xóa công việc: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và xem danh sách công việc nếu có quyền (read)
  Future<void> _readTasks(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canRead = await widget._permissionChecker.hasPermission(widget.userId, 'tasks', 'read');
      if (canRead) {
        QuerySnapshot tasksSnapshot = await FirebaseFirestore.instance.collection('tasks').get();
        for (var task in tasksSnapshot.docs) {
          print('Công việc: ${task['title']} - ${task['description']}');
        }
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền xem công việc';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xem công việc: $e';
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
      appBar: AppBar(title: const Text('Quản lý công việc')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn chờ khi đang xử lý
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _createTask(context),
                    child: const Text('Tạo công việc mới'),
                  ),
                  ElevatedButton(
                    onPressed: () => _editTask(context, 'taskID123'),
                    child: const Text('Chỉnh sửa công việc'),
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteTask(context, 'taskID123'),
                    child: const Text('Xóa công việc'),
                  ),
                  ElevatedButton(
                    onPressed: () => _readTasks(context),
                    child: const Text('Xem danh sách công việc'),
                  ),
                  _buildErrorMessage(), // Hiển thị lỗi nếu có
                ],
              ),
            ),
    );
  }
}
