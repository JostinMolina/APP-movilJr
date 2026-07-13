import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import 'loan_form_screen.dart'; // ¡Importamos el formulario final!

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProvider>().listenToLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préstamos Realizados'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LoanProvider>(
        builder: (context, loanProvider, child) {
          if (loanProvider.isFetchLoading) return const Center(child: CircularProgressIndicator());
          if (loanProvider.errorMessage != null) return Center(child: Text(loanProvider.errorMessage!));
          if (loanProvider.loans.isEmpty) return const Center(child: Text('No hay préstamos registrados.'));

          return ListView.builder(
            itemCount: loanProvider.loans.length,
            itemBuilder: (context, index) {
              final loan = loanProvider.loans[index];
              final date = "${loan.loanDate.day}/${loan.loanDate.month}/${loan.loanDate.year}";
              
              return ListTile(
                leading: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
                title: Text('${loan.bookTitle} ➡️ ${loan.readerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Fecha: $date'),
                trailing: loan.isReturned
                    ? const Chip(label: Text('Devuelto'), backgroundColor: Colors.greenAccent)
                    : IconButton(
                        icon: const Icon(Icons.assignment_return, color: Colors.redAccent),
                        tooltip: 'Marcar como devuelto',
                        onPressed: () {
                          loanProvider.markAsReturned(loan);
                        },
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abrimos el formulario de préstamos
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoanFormScreen()));
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}