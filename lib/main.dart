import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/user_management_page.dart';
import 'presentation/pages/proposal_management_page.dart';
import 'presentation/pages/task_management_page.dart';
import 'presentation/pages/create_user_page.dart';
import 'presentation/pages/company_structure_page.dart';
import 'presentation/pages/user_list_page.dart';

// Cấu hình Firebase cho Web
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyDyzfwMggg-9gGq0zYXuGW_N7fdBQOqvtM",
  authDomain: "companymanagement-fea74.firebaseapp.com",
  projectId: "companymanagement-fea74",
  storageBucket: "companymanagement-fea74.appspot.com",
  messagingSenderId: "551992631951",
  appId: "1:551992631951:web:573bfd4d4699ab9d5746fa",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase cho Web với cấu hình FirebaseOptions
  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(userId: userId); // Truyền userId vào HomePage
        },
        '/users': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return UserManagementPage(userId: userId);
        },
        '/proposals': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return ProposalManagementPage(userId: userId);
        },
        '/tasks': (context) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return TaskManagementPage(userId: userId);
        },
        '/create-user': (context) => const CreateUserPage(),
        '/company-structure': (context) => const CompanyStructurePage(),
        '/user-list': (context) => const UserListPage(),
      },
    );
  }
}
