class BookModel {
  String? id;
  String title;
  String author;
  String category;
  bool isAvailable;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.isAvailable,
  });

  // Esto convierte los datos de Firebase a nuestra app
  factory BookModel.fromJson(Map<String, dynamic> json, String documentId) {
    return BookModel(
      id: documentId,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  // Esto convierte los datos de nuestra app para guardarlos en Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'isAvailable': isAvailable,
    };
  }
}