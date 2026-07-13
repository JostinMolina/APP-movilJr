import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import 'book_form_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().listenToBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Libros'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isFetchLoading) return const Center(child: CircularProgressIndicator());
          if (bookProvider.errorMessage != null) return Center(child: Text(bookProvider.errorMessage!));
          if (bookProvider.books.isEmpty) return const Center(child: Text('No hay libros registrados.'));

          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return ListTile(
                leading: const Icon(Icons.book, color: Colors.blueAccent),
                title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${book.author} • ${book.category}'),
                trailing: Icon(book.isAvailable ? Icons.check_circle : Icons.cancel, color: book.isAvailable ? Colors.green : Colors.red),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BookFormScreen()));
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}