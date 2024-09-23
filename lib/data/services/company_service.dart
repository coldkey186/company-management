import 'package:company_management/data/models/company_model.dart';
import 'package:company_management/data/repositories/company_repository.dart';

class CompanyService {
  final CompanyRepository _companyRepository = CompanyRepository();

  Stream<List<CompanyModel>> getCompanies() {
    return _companyRepository.getCompanies();
  }

  Future<void> createCompany(String name, List<String> departments) {
    final newCompany = CompanyModel(id: '', name: name, departments: departments);
    return _companyRepository.addCompany(newCompany);
  }
}
