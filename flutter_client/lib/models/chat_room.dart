import 'message.dart';
import 'user.dart';

class ChatRoom {
  final int id;
  final String name;
  final List<User> participants;
  final bool isGroup;
  final DateTime createdAt;
  final Message? lastMessage;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.isGroup,
    required this.createdAt,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      participants: (json['participants'] as List)
          .map((user) => User.fromJson(user))
          .toList(),
      isGroup: json['is_group'],
      createdAt: DateTime.parse(json['created_at']),
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants.map((user) => user.toJson()).toList(),
      'is_group': isGroup,
      'created_at': createdAt.toIso8601String(),
      'last_message': lastMessage?.toJson(),
    };
  }
} 