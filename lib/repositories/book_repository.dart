import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart'; 

class BookRepository {
  // Apuntamos a la colección 'books' (libros) en Firebase
  final CollectionReference _booksCollection = FirebaseFirestore.instance.collection('books');

  // 1. LEER: Obtener los libros en tiempo real
  Stream<List<BookModel>> getBooksStream() {
    return _booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 2. CREAR: Agregar un nuevo libro a Firebase
  Future<void> addBook(BookModel book) async {
    await _booksCollection.add(book.toJson());
  }

  // 3. ACTUALIZAR: Modificar un libro existente
  Future<void> updateBook(String id, BookModel book) async {
    await _booksCollection.doc(id).update(book.toJson());
  }
}