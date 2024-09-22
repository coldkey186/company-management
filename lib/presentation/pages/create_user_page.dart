import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Các TextEditingController để lấy dữ liệu từ form nhập liệu
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _householdController = TextEditingController();
  final TextEditingController _technicalLevelController = TextEditingController();
  final TextEditingController _workplaceController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _contractTypeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _contractSignDateController = TextEditingController();
  final TextEditingController _contractEndDateController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _socialInsuranceController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _idCardIssueDateController = TextEditingController();
  final TextEditingController _idCardExpiryDateController = TextEditingController();
  final TextEditingController _idCardPlaceController = TextEditingController();
  final TextEditingController _oldIdCardController = TextEditingController();
  final TextEditingController _taxCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Email dùng để tạo tài khoản user
  final TextEditingController _passwordController = TextEditingController(); // Mật khẩu của user

  // Hàm xử lý việc tạo người dùng
  void _createUser() async {
    try {
      // Đăng ký người dùng với Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _fullNameController.text,
        'gender': _genderController.text,
        'dateOfBirth': _dobController.text,
        'currentAddress': _addressController.text,
        'householdRegistration': _householdController.text,
        'technicalLevel': _technicalLevelController.text,
        'workplace': _workplaceController.text,
        'position': _positionController.text,
        'department': _departmentController.text,
        'supervisor': _supervisorController.text,
        'contractType': _contractTypeController.text,
        'startDate': _startDateController.text,
        'contractSignDate': _contractSignDateController.text,
        'contractEndDate': _contractEndDateController.text,
        'salary': _salaryController.text,
        'socialInsuranceNumber': _socialInsuranceController.text,
        'idCardNumber': _idCardController.text,
        'idCardIssueDate': _idCardIssueDateController.text,
        'idCardExpiryDate': _idCardExpiryDateController.text,
        'idCardIssuePlace': _idCardPlaceController.text,
        'oldIdCardNumber': _oldIdCardController.text,
        'taxCode': _taxCodeController.text,
        'phoneNumber': _phoneNumberController.text,
        'email': _emailController.text, // Email đăng ký tài khoản
      });

      // Quay lại trang trước khi hoàn tất
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo người dùng mới: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo người dùng mới')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Họ tên', _fullNameController),
            _buildTextField('Giới tính', _genderController),
            _buildTextField('Ngày sinh (dd/MM/yyyy)', _dobController),
            _buildTextField('Nơi ở hiện tại', _addressController),
            _buildTextField('Hộ khẩu thường trú', _householdController),
            _buildTextField('Trình độ chuyên môn kỹ thuật', _technicalLevelController),
            _buildTextField('Cơ sở công tác', _workplaceController),
            _buildTextField('Chức vụ', _positionController),
            _buildTextField('Phòng ban trực thuộc', _departmentController),
            _buildTextField('Cấp trên quản lý trực tiếp', _supervisorController),
            _buildTextField('Loại hợp đồng lao động', _contractTypeController),
            _buildTextField('Thời điểm bắt đầu làm việc (dd/MM/yyyy)', _startDateController),
            _buildTextField('Thời gian ký hợp đồng (dd/MM/yyyy)', _contractSignDateController),
            _buildTextField('Thời gian hết hạn hợp đồng (dd/MM/yyyy)', _contractEndDateController),
            _buildTextField('Lương cơ bản', _salaryController),
            _buildTextField('Mã số BHXH', _socialInsuranceController),
            _buildTextField('Số căn cước công dân', _idCardController),
            _buildTextField('Ngày cấp căn cước (dd/MM/yyyy)', _idCardIssueDateController),
            _buildTextField('Ngày hết hạn căn cước (dd/MM/yyyy)', _idCardExpiryDateController),
            _buildTextField('Nơi đăng ký căn cước công dân', _idCardPlaceController),
            _buildTextField('Số CMND cũ (nếu có)', _oldIdCardController),
            _buildTextField('Mã số thuế', _taxCodeController),
            _buildTextField('Số điện thoại', _phoneNumberController),
            _buildTextField('Email', _emailController), // Email dùng để đăng ký tài khoản
            _buildTextField('Mật khẩu', _passwordController, obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Tạo người dùng'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo TextField cho form
  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
