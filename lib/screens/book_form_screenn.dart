import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  // Llave para validar que no dejen el formulario vacío
  final _formKey = GlobalKey<FormState>(); 
  
  // Controladores para leer lo que el usuario escribe
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isAvailable = true; // Por defecto el libro está disponible

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Función que se ejecuta al presionar "Guardar"
  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<BookProvider>();
      
      // Llamamos a la función que creaste en tu Provider
      final success = await provider.registerBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        category: _categoryController.text.trim(),
        isAvailable: _isAvailable,
      );

      // Si todo salió bien y la pantalla sigue abierta, regresamos al inicio
      if (success && mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('📚 Libro guardado correctamente')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al guardar el libro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<BookProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Libro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título del libro',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa el autor' : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoría (Ej. Ficción, Ciencia)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa una categoría' : null,
              ),
              const SizedBox(height: 15),
              
              SwitchListTile(
                title: const Text('¿Está disponible para préstamo?'),
                value: _isAvailable,
                activeThumbColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              
              // Botón de guardar
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : _saveBook,
                  child: isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar Libro', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}