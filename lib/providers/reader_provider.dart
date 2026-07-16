import 'dart:async';
import 'package:flutter/material.dart';
import '../models/reader_model.dart';
import '../repositories/reader_repository.dart';

class ReaderProvider extends ChangeNotifier {
  final ReaderRepository _readerRepository = ReaderRepository();
  StreamSubscription<List<ReaderModel>>? _readersSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetchLoading = true;
  bool get isFetchLoading => _isFetchLoading;

  List<ReaderModel> _readers = [];
  List<ReaderModel> get readers => _readers;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToReaders() {
    if (_readersSubscription != null) return;
    _isFetchLoading = true;
    _errorMessage = null;

    _readersSubscription = _readerRepository.getReadersStream().listen(
      (readerList) {
        _readers = readerList;
        _isFetchLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error al obtener los lectores: $error';
        _isFetchLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> registerReader({
    required String name,
    required String membershipId,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newReader = ReaderModel(
        name: name,
        membershipId: membershipId,
        phone: phone,
      );
      await _readerRepository.addReader(newReader);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _readersSubscription?.cancel();
    super.dispose();
  }
}
