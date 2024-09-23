import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  String id;
  String name;
  List<String> departments;

  CompanyModel({required this.id, required this.name, required this.departments});

  factory CompanyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CompanyModel(
      id: doc.id,
      name: data['name'] ?? '',
      departments: List<String>.from(data['departments'] ?? []),
    );
  }
}
