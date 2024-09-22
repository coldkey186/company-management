import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        if (email == 'coldkey1111@gmail.com') {
          // Gán đầy đủ quyền cho tài khoản admin trong Firestore
          await _firestore.collection('users_permissions').doc(user.uid).set({
            'tasks': {
              'create': true,
              'edit': true,
              'delete': true,
              'approve': true,
              'read': true,
            },
            'proposals': {
              'create': true,
              'edit': true,
              'delete': true,
              'approve': true,
              'read': true,
            },
            'user_management': {
              'create': true,
              'edit': true,
              'delete': true,
              'approve': true,
              'read': true,
            },
          }, SetOptions(merge: true));

          // Lưu thông tin tài khoản admin vào Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'name': 'Admin',
            'role': 'admin',
            'created_at': DateTime.now(),
          }, SetOptions(merge: true));
        }

        // Điều hướng đến HomePage với userId
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: user.uid,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đăng nhập thất bại: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Đăng Nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
