import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_management/data/models/company_model.dart';

class CompanyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách các cơ sở
  Stream<List<CompanyModel>> getCompanies() {
    return _firestore.collection('company_structure').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CompanyModel.fromFirestore(doc)).toList());
  }

  // Thêm mới cơ sở
  Future<void> addCompany(CompanyModel company) {
    return _firestore.collection('company_structure').add({
      'name': company.name,
      'departments': company.departments,
    });
  }
}
