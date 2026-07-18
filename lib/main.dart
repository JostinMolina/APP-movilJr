import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/book_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/loan_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // 1. Garantiza la comunicación con el motor de Flutter antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializador de Firebase (lee de manera nativa tu google-services.json)
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
      ],
      child: MaterialApp(
        title: 'Gestión de Biblioteca',
        debugShowCheckedModeBanner: false,
        // Agregamos consistencia de diseño para el examen
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF312E81), // Azul índigo elegante
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
