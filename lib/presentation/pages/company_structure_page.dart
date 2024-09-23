import 'package:flutter/material.dart';
import 'package:company_management/data/services/company_service.dart';
import 'package:company_management/data/models/company_model.dart';

class CompanyStructurePage extends StatefulWidget {
  const CompanyStructurePage({super.key});

  @override
  _CompanyStructurePageState createState() => _CompanyStructurePageState();
}

class _CompanyStructurePageState extends State<CompanyStructurePage> {
  final CompanyService _companyService = CompanyService();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _departmentNameController = TextEditingController();
  final List<String> _departments = [];

  // Tạo mới cơ sở
  Future<void> _createCompany() async {
    if (_companyNameController.text.isEmpty || _departments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tên cơ sở và phòng ban không được để trống')));
      return;
    }
    await _companyService.createCompany(_companyNameController.text, _departments);
    _companyNameController.clear();
    _departments.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cơ sở đã được tạo')));
    setState(() {}); // Để làm mới danh sách cơ sở
  }

  // Thêm phòng ban vào danh sách
  void _addDepartment() {
    if (_departmentNameController.text.isNotEmpty) {
      setState(() {
        _departments.add(_departmentNameController.text);
        _departmentNameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sơ đồ công ty')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(labelText: 'Tên cơ sở'),
                ),
                TextField(
                  controller: _departmentNameController,
                  decoration: const InputDecoration(labelText: 'Thêm phòng ban'),
                ),
                ElevatedButton(
                  onPressed: _addDepartment,
                  child: const Text('Thêm phòng ban'),
                ),
                Wrap(
                  children: _departments
                      .map((dept) => Chip(label: Text(dept)))
                      .toList(),
                ),
                ElevatedButton(
                  onPressed: _createCompany,
                  child: const Text('Tạo cơ sở'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CompanyModel>>(
              stream: _companyService.getCompanies(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final companies = snapshot.data!;
                return ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return ListTile(
                      title: Text(company.name),
                      subtitle: Text('Phòng ban: ${company.departments.join(', ')}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
