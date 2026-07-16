import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  final CollectionReference _db = FirebaseFirestore.instance.collection('books');
  List<Book> _books = [];

  List<Book> get books => _books;

  void loadBooks() {
    _db.snapshots().listen((snapshot) {
      _books = snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  Future<void> addBook(Book book) async {
    await _db.add(book.toMap());
  }

  Future<void> updateBook(String id, Book book) async {
    await _db.doc(id).update(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await _db.doc(id).delete();
  }

  Future<void> updateAvailability(String id, bool status) async {
    await _db.doc(id).update({'isAvailable': status});
  }
}