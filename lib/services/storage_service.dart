import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<bool> deleteFile(String url) async {
    try {
      await _storage.refFromURL(url).delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  Future<String?> uploadProfileImage(File file, String userId) async {
    final path = 'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await uploadFile(file, path);
  }

  Future<String?> uploadChatFile(File file, String chatRoomId) async {
    final extension = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final path = 'chat_files/$chatRoomId/$fileName';
    return await uploadFile(file, path);
  }
}