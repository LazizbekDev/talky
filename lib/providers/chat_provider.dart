import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:talky/services/chat/chat_service.dart';
import 'package:talky/services/storage_service.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider(
    this._chatService,
    this._storageService,
  );
  final ChatService _chatService;
  final StorageService _storageService;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  String chatRoomId = '';

  Future<void> initializeChatRoom(String chatPartnerId) async {
    if (chatPartnerId.isEmpty) {
      debugPrint('Error: chatPartnerId is empty.');
      return;
    }
    _messages = [];
    chatRoomId = await _chatService.initializeChatRoom(chatPartnerId);
    debugPrint('ChatRoom ID initialized: $chatRoomId');
    notifyListeners();
  }

  Future<void> sendMessage({
    required String chatPartnerId,
    String? text,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    if (chatRoomId.isEmpty) {
      await initializeChatRoom(chatPartnerId);
    }
    await _chatService.sendMessage(
      chatRoomId: chatRoomId,
      text: text,
      fileBytes: fileBytes,
      fileName: fileName,
    );
    notifyListeners();
  }

  Future<String?> uploadImage(Uint8List imageBytes) async {
    try {
      return await _storageService.uploadFile(
        'chatImages/chat_image_${DateTime.now().millisecondsSinceEpoch}.png',
        imageBytes,
      );
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<String?> uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      return await _storageService.uploadFile(
        'chatFiles/$fileName',
        fileBytes,
      );
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> fetchChatData(String chatRoomId) async {
    try {
      _messages = await _chatService.fetchMessages(chatRoomId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching chat data: $e');
    }
  }

  Stream<String?> getLastMessage(String chatPartnerId) {
    if (chatRoomId.isEmpty) {
      debugPrint('Warning: chatRoomId is empty, attempting to initialize.');
      initializeChatRoom(chatPartnerId);
    }
    return _chatService.getLastMessageStream(chatRoomId, chatPartnerId);
  }
}
