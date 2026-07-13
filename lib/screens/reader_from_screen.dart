import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reader_provider.dart';

class ReaderFormScreen extends StatefulWidget {
  const ReaderFormScreen({super.key});

  @override
  State<ReaderFormScreen> createState() => _ReaderFormScreenState();
}

class _ReaderFormScreenState extends State<ReaderFormScreen> {
  final _formKey = GlobalKey<FormState>(); 
  
  final _nameController = TextEditingController();
  final _membershipIdController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _membershipIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveReader() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ReaderProvider>();
      
      final success = await provider.registerReader(
        name: _nameController.text.trim(),
        membershipId: _membershipIdController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('👤 Lector guardado correctamente')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al guardar el lector')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ReaderProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Lector'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _membershipIdController,
                decoration: const InputDecoration(
                  labelText: 'Matrícula / ID de Membresía',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa la matrícula' : null,
              ),
              const SizedBox(height: 15),
              
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Ingresa el teléfono' : null,
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : _saveReader,
                  child: isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar Lector', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}