// lib/data/services/proposal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/proposal_model.dart';

class ProposalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách các đơn từ từ Firestore
  Future<List<ProposalModel>> fetchProposals() async {
    QuerySnapshot snapshot = await _db.collection('proposals').get();
    return snapshot.docs.map((doc) => ProposalModel.fromFirestore(doc)).toList();
  }

  // Tạo đơn từ mới
  Future<void> createProposal(ProposalModel proposal) async {
    await _db.collection('proposals').add(proposal.toFirestore());
  }
}
