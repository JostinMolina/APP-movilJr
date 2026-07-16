import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reader_provider.dart';
import 'reader_form_screen.dart';

class ReadersScreen extends StatefulWidget {
  const ReadersScreen({super.key});

  @override
  State<ReadersScreen> createState() => _ReadersScreenState();
}

class _ReadersScreenState extends State<ReadersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReaderProvider>().listenToReaders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Lectores'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ReaderProvider>(
        builder: (context, readerProvider, child) {
          if (readerProvider.isFetchLoading) return const Center(child: CircularProgressIndicator());
          if (readerProvider.errorMessage != null) return Center(child: Text(readerProvider.errorMessage!));
          if (readerProvider.readers.isEmpty) return const Center(child: Text('No hay lectores registrados.'));

          return ListView.builder(
            itemCount: readerProvider.readers.length,
            itemBuilder: (context, index) {
              final reader = readerProvider.readers[index];
              return ListTile(
                leading: const Icon(Icons.person, color: Colors.teal),
                title: Text(reader.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Matrícula: ${reader.membershipId} • Tel: ${reader.phone}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReaderFormScreen()));
        },
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}