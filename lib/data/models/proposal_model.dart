// lib/data/models/proposal_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProposalModel {
  final String id;
  final String content;
  final String status;
  final String userId;
  final String? approvedBy;
  final DateTime createdAt;

  ProposalModel({
    required this.id,
    required this.content,
    required this.status,
    required this.userId,
    this.approvedBy,
    required this.createdAt,
  });

  // Chuyển đổi từ Firestore document thành ProposalModel
  factory ProposalModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProposalModel(
      id: doc.id,
      content: data['content'],
      status: data['status'],
      userId: data['user_id'],
      approvedBy: data['approved_by'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  // Chuyển đổi ProposalModel thành Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'status': status,
      'user_id': userId,
      'approved_by': approvedBy,
      'created_at': createdAt,
    };
  }
}
