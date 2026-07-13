import 'dart:async';

import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../repositories/book_repository.dart';
class BookProvider extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();

  StreamSubscription<List<BookModel>>? _booksSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetchLoading = true;
  bool get isFetchLoading => _isFetchLoading;

  List<BookModel> _books = [];
  List<BookModel> get books => _books;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToBooks() {
    if (_booksSubscription != null) return;

    _isFetchLoading = true;
    _errorMessage = null;

    _booksSubscription = _bookRepository.getBooksStream().listen(
      (bookList) {
        _books = bookList;
        _errorMessage = null;
        _isFetchLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error al obtener los libros: $error';
        _isFetchLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> registerBook({
    required String title,
    required String author,
    required String category,
    required bool isAvailable,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newBook = BookModel(
        title: title,
        author: author,
        category: category,
        isAvailable: isAvailable,
      );

      await _bookRepository.addBook(newBook);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExistingBook({
    required String id,
    required String title,
    required String author,
    required String category,
    required bool isAvailable,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedBook = BookModel(
        id: id,
        title: title,
        author: author,
        category: category,
        isAvailable: isAvailable,
      );

      await _bookRepository.updateBook(id, updatedBook);

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
    _booksSubscription?.cancel();
    super.dispose();
  }
}