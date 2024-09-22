// lib/domain/entities/proposal_entity.dart
class ProposalEntity {
  final String id;
  final String content;
  final String status;
  final String userId;
  final String? approvedBy;
  final DateTime createdAt;

  ProposalEntity({
    required this.id,
    required this.content,
    required this.status,
    required this.userId,
    this.approvedBy,
    required this.createdAt,
  });
}
