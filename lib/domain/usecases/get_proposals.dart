// lib/domain/usecases/get_proposals.dart
import '../entities/proposal_entity.dart';
import '../../data/repositories/proposal_repository.dart';

class GetProposals {
  final ProposalRepository proposalRepository;

  GetProposals(this.proposalRepository);

  Future<List<ProposalEntity>> execute() async {
    // Lấy danh sách các đơn từ từ repository
    return await proposalRepository.getProposals();
  }
}
