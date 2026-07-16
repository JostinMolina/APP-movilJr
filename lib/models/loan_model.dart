import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModel {
  String? id;
  String bookId; // ID del libro prestado
  String bookTitle; // Guardamos el título para mostrarlo fácil en pantalla
  String readerId; // ID del lector que se lo lleva
  String readerName; // Nombre del lector
  DateTime loanDate; // Fecha en la que se prestó
  bool isReturned; // ¿Ya lo devolvió?

  LoanModel({
    this.id,
    required this.bookId,
    required this.bookTitle,
    required this.readerId,
    required this.readerName,
    required this.loanDate,
    this.isReturned = false, // Por defecto no está devuelto
  });

  factory LoanModel.fromJson(Map<String, dynamic> json, String documentId) {
    return LoanModel(
      id: documentId,
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      readerId: json['readerId'] ?? '',
      readerName: json['readerName'] ?? '',
      // Firebase guarda las fechas como "Timestamp", las convertimos a DateTime
      loanDate: (json['loanDate'] as Timestamp).toDate(),
      isReturned: json['isReturned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'readerId': readerId,
      'readerName': readerName,
      'loanDate': Timestamp.fromDate(
        loanDate,
      ), // Convertimos de vuelta a Timestamp
      'isReturned': isReturned,
    };
  }
}
