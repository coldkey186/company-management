import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_management/permissions/permission_checker.dart';

class ProposalManagementPage extends StatefulWidget {
  final String userId;
  final PermissionChecker _permissionChecker = PermissionChecker();

  ProposalManagementPage({super.key, required this.userId});

  @override
  _ProposalManagementPageState createState() => _ProposalManagementPageState();
}

class _ProposalManagementPageState extends State<ProposalManagementPage> {
  bool _isLoading = false; // Trạng thái loading
  String? _errorMessage; // Lưu trữ thông báo lỗi

  // Hiển thị thông báo lỗi nếu có
  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink(); // Nếu không có lỗi, không hiển thị
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  // Kiểm tra quyền và tạo đề xuất mới nếu có quyền
  Future<void> _createProposal(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset lỗi trước khi thao tác
    });

    try {
      bool canCreate = await widget._permissionChecker.hasPermission(widget.userId, 'proposals', 'create');
      if (canCreate) {
        await FirebaseFirestore.instance.collection('proposals').add({
          'title': 'Đề xuất mới',
          'description': 'Mô tả đề xuất',
          'createdAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đề xuất đã được tạo')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền tạo đề xuất';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tạo đề xuất: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và chỉnh sửa đề xuất nếu có quyền
  Future<void> _editProposal(BuildContext context, String proposalId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canEdit = await widget._permissionChecker.hasPermission(widget.userId, 'proposals', 'edit');
      if (canEdit) {
        await FirebaseFirestore.instance.collection('proposals').doc(proposalId).update({
          'title': 'Đề xuất đã chỉnh sửa',
          'updatedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đề xuất đã được chỉnh sửa')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền chỉnh sửa đề xuất';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi chỉnh sửa đề xuất: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và xóa đề xuất nếu có quyền
  Future<void> _deleteProposal(BuildContext context, String proposalId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canDelete = await widget._permissionChecker.hasPermission(widget.userId, 'proposals', 'delete');
      if (canDelete) {
        await FirebaseFirestore.instance.collection('proposals').doc(proposalId).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đề xuất đã được xóa')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền xóa đề xuất';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xóa đề xuất: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và phê duyệt đề xuất nếu có quyền
  Future<void> _approveProposal(BuildContext context, String proposalId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canApprove = await widget._permissionChecker.hasPermission(widget.userId, 'proposals', 'approve');
      if (canApprove) {
        await FirebaseFirestore.instance.collection('proposals').doc(proposalId).update({
          'approved': true,
          'approvedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đề xuất đã được phê duyệt')));
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền phê duyệt đề xuất';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi phê duyệt đề xuất: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Kiểm tra quyền và xem danh sách đề xuất nếu có quyền (read)
  Future<void> _readProposals(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool canRead = await widget._permissionChecker.hasPermission(widget.userId, 'proposals', 'read');
      if (canRead) {
        QuerySnapshot proposalsSnapshot = await FirebaseFirestore.instance.collection('proposals').get();
        for (var proposal in proposalsSnapshot.docs) {
          print('Đề xuất: ${proposal['title']} - ${proposal['description']}');
        }
      } else {
        setState(() {
          _errorMessage = 'Bạn không có quyền xem đề xuất';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xem đề xuất: $e';
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
      appBar: AppBar(title: const Text('Quản lý đề xuất')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn loading khi đang xử lý
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _createProposal(context),
                    child: const Text('Tạo đề xuất mới'),
                  ),
                  ElevatedButton(
                    onPressed: () => _editProposal(context, 'proposalID123'),
                    child: const Text('Chỉnh sửa đề xuất'),
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteProposal(context, 'proposalID123'),
                    child: const Text('Xóa đề xuất'),
                  ),
                  ElevatedButton(
                    onPressed: () => _approveProposal(context, 'proposalID123'),
                    child: const Text('Phê duyệt đề xuất'),
                  ),
                  ElevatedButton(
                    onPressed: () => _readProposals(context),
                    child: const Text('Xem danh sách đề xuất'),
                  ),
                  _buildErrorMessage(), // Hiển thị lỗi nếu có
                ],
              ),
            ),
    );
  }
}
