import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, Uint8List fileBytes) async {
    final storageRef = _storage.ref().child(path);
    final uploadTask = await storageRef.putData(fileBytes);
    return await uploadTask.ref.getDownloadURL();
  }
}
