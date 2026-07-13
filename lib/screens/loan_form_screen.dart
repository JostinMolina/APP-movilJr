import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../providers/book_provider.dart';
import '../providers/reader_provider.dart';
import '../models/book_model.dart';
import '../models/reader_model.dart';

class LoanFormScreen extends StatefulWidget {
  const LoanFormScreen({super.key});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Variables para guardar lo que el usuario seleccione
  BookModel? _selectedBook;
  ReaderModel? _selectedReader;

  void _saveLoan() async {
    if (_formKey.currentState!.validate()) {
      final loanProvider = context.read<LoanProvider>();

      // Registramos el préstamo con los datos seleccionados
      final success = await loanProvider.registerLoan(
        bookId: _selectedBook!.id!,
        bookTitle: _selectedBook!.title,
        readerId: _selectedReader!.id!,
        readerName: _selectedReader!.name,
      );

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Préstamo registrado correctamente')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al registrar el préstamo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos los libros (solo los disponibles) y todos los lectores
    final availableBooks = context.watch<BookProvider>().books.where((b) => b.isAvailable).toList();
    final readers = context.watch<ReaderProvider>().readers;
    final isLoading = context.watch<LoanProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Préstamo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Menú desplegable para seleccionar el Libro
              DropdownButtonFormField<BookModel>(
                decoration: const InputDecoration(
                  labelText: 'Selecciona un Libro',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                items: availableBooks.map((book) {
                  return DropdownMenuItem(
                    value: book,
                    child: Text(book.title),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBook = value;
                  });
                },
                validator: (value) => value == null ? 'Por favor elige un libro' : null,
              ),
              const SizedBox(height: 20),

              // Menú desplegable para seleccionar el Lector
              DropdownButtonFormField<ReaderModel>(
                decoration: const InputDecoration(
                  labelText: 'Selecciona un Lector',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: readers.map((reader) {
                  return DropdownMenuItem(
                    value: reader,
                    child: Text(reader.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReader = value;
                  });
                },
                validator: (value) => value == null ? 'Por favor elige un lector' : null,
              ),
              const SizedBox(height: 30),

              // Botón de guardar
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : _saveLoan,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Registrar Préstamo', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}