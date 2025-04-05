import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../models/chat_room.dart';
import '../models/message.dart';
import 'auth_service.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:8000/api';
  final AuthService _authService;
  WebSocketChannel? _channel;
  Function(Message)? onMessageReceived;
  Function(String, bool)? onTypingStatusChanged;

  ChatService(this._authService);

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final token = await _authService.token;
      final response = await http.get(
        Uri.parse('$baseUrl/chat-rooms/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((room) => ChatRoom.fromJson(room)).toList();
      }
      return [];
    } catch (e) {
      print('Get chat rooms error: $e');
      return [];
    }
  }

  Future<List<Message>> getMessages(int roomId) async {
    try {
      final token = await _authService.token;
      final response = await http.get(
        Uri.parse('$baseUrl/messages/?room=$roomId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((msg) => Message.fromJson(msg)).toList();
      }
      return [];
    } catch (e) {
      print('Get messages error: $e');
      return [];
    }
  }

  void connectToChat(int roomId) {
    final wsUrl = Uri.parse('ws://localhost:8000/ws/chat/$roomId/');
    _channel = WebSocketChannel.connect(wsUrl);
    _channel?.stream.listen(
      (data) {
        final message = json.decode(data);
        if (message['type'] == 'message') {
          onMessageReceived?.call(Message.fromJson(message));
        } else if (message['type'] == 'typing') {
          onTypingStatusChanged?.call(
            message['user'],
            message['is_typing'],
          );
        }
      },
      onError: (error) => print('WebSocket error: $error'),
      onDone: () => print('WebSocket connection closed'),
    );
  }

  void sendMessage(String content) {
    if (_channel != null) {
      _channel!.sink.add(json.encode({
        'type': 'message',
        'message': content,
      }));
    }
  }

  void sendTypingStatus(bool isTyping) {
    if (_channel != null) {
      _channel!.sink.add(json.encode({
        'type': 'typing',
        'is_typing': isTyping,
      }));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
} 