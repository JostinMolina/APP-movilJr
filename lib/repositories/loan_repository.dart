import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loan_model.dart'; 

class LoanRepository {
  final CollectionReference _loansCollection = FirebaseFirestore.instance.collection('loans');

  // Obtener todos los préstamos en tiempo real
  Stream<List<LoanModel>> getLoansStream() {
    return _loansCollection
        .orderBy('loanDate', descending: true) // Los más recientes primero
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LoanModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Registrar un nuevo préstamo
  Future<void> addLoan(LoanModel loan) async {
    await _loansCollection.add(loan.toJson());
  }

  // Actualizar un préstamo (por ejemplo, para marcarlo como devuelto)
  Future<void> updateLoan(String id, LoanModel loan) async {
    await _loansCollection.doc(id).update(loan.toJson());
  }
}