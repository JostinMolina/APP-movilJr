import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // 👈 Importación obligatoria para detectar si corre en la Web
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/book_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/loan_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // 1. Garantiza la comunicación con el motor de Flutter antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Detección inteligente de plataforma para inicializar Firebase
    if (kIsWeb) {
      // Configuración exclusiva para Web (Los datos de tu proyecto se leen de forma explícita aquí)
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyA-5nok14ucJDXarv99dw4vedZBXMjKLbU",
          appId:
              "1:854113737528:web:e0a0a57e62a12dfdcd357f", // Tu identificador de App Web
          messagingSenderId:
              "854113737528", // Tu número de proyecto verificado en image_6b68a5.png
          projectId:
              "app-movil-b9a70", // Tu ID de proyecto verificado en image_6b68a5.png
          storageBucket:
              "app-movil-b9a70.firebasestorage.app", // Tu bucket de almacenamiento
        ),
      );
      debugPrint(" Firebase inicializado con éxito en plataforma Web (Chrome)");
    } else {
      // Configuración automática nativa para Android (lee tu google-services.json en caliente)
      await Firebase.initializeApp();
      debugPrint("Firebase inicializado con éxito en plataforma Android");
    }
  } catch (e) {
    debugPrint(" Error crítico en la inicialización de Firebase: $e");
  }

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
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(
            0xFF312E81,
          ), // Azul índigo de tu guía de diseño
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
