import 'package:flutter/material.dart';
import 'books_screen.dart';
import 'readers_screen.dart';
import 'loans_screen.dart'; // ¡Importamos la nueva pantalla!

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; 

  // Agregamos la pantalla de préstamos a la lista
  final List<Widget> _screens = [
    const BooksScreen(),
    const ReadersScreen(),
    const LoansScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        selectedItemColor: Colors.deepPurple, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Libros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Lectores',
          ),
          // ¡Aquí está la tercera pestaña!
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Préstamos',
          ),
        ],
      ),
    );
  }
}