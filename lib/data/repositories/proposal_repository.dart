// lib/data/repositories/proposal_repository.dart
import '../models/proposal_model.dart';
import '../services/proposal_service.dart';
import '../../domain/entities/proposal_entity.dart';

class ProposalRepository {
  final ProposalService proposalService = ProposalService();

  // Lấy danh sách đơn từ
  Future<List<ProposalEntity>> getProposals() async {
    List<ProposalModel> proposals = await proposalService.fetchProposals();
    return proposals.map((model) => ProposalEntity(
      id: model.id,
      content: model.content,
      status: model.status,
      userId: model.userId,
      approvedBy: model.approvedBy,
      createdAt: model.createdAt,
    )).toList();
  }

  // Tạo đơn từ mới
  Future<void> createProposal(ProposalEntity proposal) async {
    ProposalModel model = ProposalModel(
      id: proposal.id,
      content: proposal.content,
      status: proposal.status,
      userId: proposal.userId,
      approvedBy: proposal.approvedBy,
      createdAt: proposal.createdAt,
    );
    await proposalService.createProposal(model);
  }
}
