import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookRepository {
  final CollectionReference _booksCollection = FirebaseFirestore.instance.collection('books');

  Stream<List<Book>> getBooksStream() {
    return _booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addBook(Book book) async {
    await _booksCollection.add(book.toMap());
  }

  Future<void> updateBook(String id, Book book) async {
    await _booksCollection.doc(id).update(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await _booksCollection.doc(id).delete();
  }
}
