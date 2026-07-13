import 'dart:async';
import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../repositories/loan_repository.dart';

class LoanProvider extends ChangeNotifier {
  final LoanRepository _loanRepository = LoanRepository();
  StreamSubscription<List<LoanModel>>? _loansSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetchLoading = true;
  bool get isFetchLoading => _isFetchLoading;

  List<LoanModel> _loans = [];
  List<LoanModel> get loans => _loans;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToLoans() {
    if (_loansSubscription != null) return;
    _isFetchLoading = true;
    _errorMessage = null;

    _loansSubscription = _loanRepository.getLoansStream().listen(
      (loanList) {
        _loans = loanList;
        _isFetchLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error al obtener los préstamos: $error';
        _isFetchLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> registerLoan({
    required String bookId,
    required String bookTitle,
    required String readerId,
    required String readerName,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newLoan = LoanModel(
        bookId: bookId,
        bookTitle: bookTitle,
        readerId: readerId,
        readerName: readerName,
        loanDate: DateTime.now(), // Toma la fecha actual del sistema
        isReturned: false,
      );
      await _loanRepository.addLoan(newLoan);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Función extra para marcar que ya devolvieron el libro
  Future<bool> markAsReturned(LoanModel loan) async {
    try {
      loan.isReturned = true;
      await _loanRepository.updateLoan(loan.id!, loan);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _loansSubscription?.cancel();
    super.dispose();
  }
}