import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/message_model.dart';
// Ensure that the file '../models/message_model.dart' defines a class named 'MessageModel'
import '../models/chat_room_model.dart';
import '../models/user_model.dart';

// Ensure MessageType is imported or defined
// If MessageType is defined in message_model.dart, this import is sufficient.
// Otherwise, define the enum below or import from the correct file.

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  Stream<List<ChatRoomModel>> getUserChatRooms(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<MessageModel>> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String content,
    required String senderId,
    required String senderName,
    MessageType type = MessageType.text,
    File? file,
    Map<String, dynamic>? gameData,
  }) async {
    String? fileUrl;
    String? fileName;

    if (file != null) {
      final fileName = '${_uuid.v4()}_${file.path.split('/').last}';
      final ref = _storage.ref().child('chat_files').child(fileName);
      await ref.putFile(file);
      fileUrl = await ref.getDownloadURL();
    }

    final message = MessageModel(
      id: _uuid.v4(),
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: type,
      timestamp: DateTime.now(),
      fileUrl: fileUrl,
      fileName: fileName,
      gameData: gameData,
    );

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());

    // Update last message in chat room
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': content,
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<String> createDirectChat(
      String currentUserId, String otherUserId) async {
    final chatRoomId = _generateDirectChatId(currentUserId, otherUserId);

    final chatRoom = ChatRoomModel(
      id: chatRoomId,
      name: 'Direct Chat',
      type: ChatType.direct,
      participants: [currentUserId, otherUserId],
      lastMessageTime: DateTime.now(),
      createdBy: currentUserId,
    );

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .set(chatRoom.toMap());
    return chatRoomId;
  }

  Future<String> createGroupChat(
      String name, List<String> participants, String createdBy) async {
    final chatRoomId = _uuid.v4();

    final chatRoom = ChatRoomModel(
      id: chatRoomId,
      name: name,
      type: ChatType.group,
      participants: participants,
      lastMessageTime: DateTime.now(),
      createdBy: createdBy,
    );

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .set(chatRoom.toMap());
    return chatRoomId;
  }

  String _generateDirectChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Stream<List<UserModel>> searchUsers(String query) {
    return _firestore
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThan: query + 'z')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }
}
