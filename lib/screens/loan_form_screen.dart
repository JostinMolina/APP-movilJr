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

  Book? _selectedBook;
  ReaderModel? _selectedReader;
  bool _isLoading = false;

  void _saveLoan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final loanProvider = context.read<LoanProvider>();

      try {
        await loanProvider.registerLoan(
          bookId: _selectedBook!.id,
          bookTitle: _selectedBook!.title,
          readerId: _selectedReader!.id!,
          readerName: _selectedReader!.name,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Préstamo registrado correctamente')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar el préstamo')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableBooks = context
        .watch<BookProvider>()
        .books
        .where((b) => b.isAvailable)
        .toList();
    final readers = context.watch<ReaderProvider>().readers;

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
              DropdownButtonFormField<Book>(
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
                validator: (value) =>
                    value == null ? 'Por favor elige un libro' : null,
              ),
              const SizedBox(height: 20),
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
                validator: (value) =>
                    value == null ? 'Por favor elige un lector' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _saveLoan,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Registrar Préstamo',
                          style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
