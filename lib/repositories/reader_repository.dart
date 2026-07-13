import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reader_model.dart'; 

class ReaderRepository {
  // Esta es la línea que define a qué colección de Firebase nos conectamos
  final CollectionReference _readersCollection = FirebaseFirestore.instance.collection('readers');

  Stream<List<ReaderModel>> getReadersStream() {
    return _readersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReaderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addReader(ReaderModel reader) async {
    await _readersCollection.add(reader.toJson());
  }

  Future<void> updateReader(String id, ReaderModel reader) async {
    await _readersCollection.doc(id).update(reader.toJson());
  }
}