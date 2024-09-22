import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyStructurePage extends StatefulWidget {
  const CompanyStructurePage({super.key});

  @override
  _CompanyStructurePageState createState() => _CompanyStructurePageState();
}

class _CompanyStructurePageState extends State<CompanyStructurePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _locationAddressController = TextEditingController();
  final TextEditingController _departmentNameController = TextEditingController();
  String? _selectedLocation;

  void _createLocation() async {
    await _firestore.collection('locations').add({
      'name': _locationNameController.text,
      'address': _locationAddressController.text,
    });
    _locationNameController.clear();
    _locationAddressController.clear();
  }

  void _createDepartment() async {
    if (_selectedLocation != null) {
      await _firestore.collection('departments').add({
        'name': _departmentNameController.text,
        'locationId': _selectedLocation,
      });
      _departmentNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hãy chọn cơ sở trước khi tạo phòng ban'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sơ đồ công ty')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tạo Cơ Sở'),
                TextField(controller: _locationNameController, decoration: const InputDecoration(labelText: 'Tên cơ sở')),
                TextField(controller: _locationAddressController, decoration: const InputDecoration(labelText: 'Địa chỉ')),
                ElevatedButton(onPressed: _createLocation, child: const Text('Tạo cơ sở')),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tạo Phòng Ban'),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('locations').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return DropdownButton<String>(
                      hint: const Text('Chọn cơ sở'),
                      value: _selectedLocation,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['name']),
                        );
                      }).toList(),
                    );
                  },
                ),
                TextField(controller: _departmentNameController, decoration: const InputDecoration(labelText: 'Tên phòng ban')),
                ElevatedButton(onPressed: _createDepartment, child: const Text('Tạo phòng ban')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
