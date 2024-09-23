import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String userId; // Nhận userId từ constructor

  const HomePage({required this.userId, super.key}); // Constructor nhận userId

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _role;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // Kiểm tra vai trò của người dùng từ Firestore
  Future<void> _checkUserRole() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(widget.userId).get();
      setState(() {
        _role = userDoc['role'];
      });
    } catch (e) {
      print('Lỗi khi lấy vai trò người dùng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chính'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị email của người dùng
            Text('Xin chào, ${_auth.currentUser?.email ?? 'Người dùng'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến trang quản lý công việc
                Navigator.pushNamed(context, '/tasks', arguments: widget.userId);
              },
              child: const Text('Quản lý công việc'),
            ),
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến trang quản lý đơn từ
                Navigator.pushNamed(context, '/proposals', arguments: widget.userId);
              },
              child: const Text('Quản lý đơn từ'),
            ),
            if (_role == 'admin') // Nếu là admin, hiển thị nút Quản lý người dùng
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/users', arguments: widget.userId);
                },
                child: const Text('Quản lý người dùng'),
              ),
            if (_role == 'admin') // Nếu là admin, hiển thị nút Sơ đồ công ty
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/company-structure');
                },
                child: const Text('Sơ đồ công ty'),
              ),
          ],
        ),
      ),
    );
  }
}
